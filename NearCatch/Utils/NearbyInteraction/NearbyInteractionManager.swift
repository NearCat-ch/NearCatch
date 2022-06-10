//
//  NearbyInteractionManager.swift
//  NearCatch
//
//  Created by Wonhyuk Choi on 2022/06/09.
//

import Foundation
import NearbyInteraction
import MultipeerConnectivity

class NearbyInteractionManager: NSObject, ObservableObject {
    
    
    // MARK: - Distance and direction state.
    
    // 범프 한계 거리
    let nearbyDistanceThreshold: Float = 0.1

    enum DistanceDirectionState {
        case closeUpInFOV, notCloseUpInFOV, outOfFOV, unknown
    }
    
    // MARK: - Class variables
    var session: NISession?
    var peerDiscoveryToken: NIDiscoveryToken?
    let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    var currentDistanceDirectionState: DistanceDirectionState = .unknown
    var mpc: MPCSession?
    var connectedPeer: MCPeerID?
    var sharedTokenWithPeer = false
    var peerDisplayName: String?
    var receivedText: String?
    
    func startup() {
        // NISession 생성
        session = NISession()
        
        // delegate 지정
        session?.delegate = self
        
        // Because the session is new, reset the token-shared flag.
        sharedTokenWithPeer = false
        
        // If `connectedPeer` exists, share the discovery token, if needed.
        if connectedPeer != nil && mpc != nil {
            if let myToken = session?.discoveryToken {
                if !sharedTokenWithPeer {
                    shareMyDiscoveryToken(token: myToken)
                }
                guard let peerToken = peerDiscoveryToken else {
                    return
                }
                let config = NINearbyPeerConfiguration(peerToken: peerToken)
                session?.run(config)
            } else {
                fatalError("Unable to get self discovery token, is this session invalidated?")
            }
        } else {
            startupMPC()
            
            // Set the display state.
            currentDistanceDirectionState = .unknown
        }
    }
    
    // TODO: 세션 종료 초기화 설정
    func shutdown() {
        shutdownMPC()
        session?.pause()
        session = nil
        connectedPeer = nil
        peerDiscoveryToken = nil
        session?.invalidate()
        sharedTokenWithPeer = false
        currentDistanceDirectionState = .unknown
    }
    
    // MARK: - Discovery token sharing and receiving using MPC.
    
    func startupMPC() {
        if mpc == nil {
            // Prevent Simulator from finding devices.
        #if targetEnvironment(simulator)
            mpc = MPCSession(service: "nearcatch", identity: "com.2pm.NearCatch", maxPeers: 1)
        #else
            mpc = MPCSession(service: "nearcatch", identity: "com.2pm.NearCatch", maxPeers: 1)
        #endif
            mpc?.peerConnectedHandler = connectedToPeer
            mpc?.peerDataHandler = dataReceivedHandler
            mpc?.peerDisconnectedHandler = disconnectedFromPeer
        }
        mpc?.invalidate()
        mpc?.start()
    }
    
    func shutdownMPC() {
        mpc?.invalidate()
        mpc = nil
    }
    
    func connectedToPeer(peer: MCPeerID) {
        guard let myToken = session?.discoveryToken else {
            fatalError("Unexpectedly failed to initialize nearby interaction session.")
        }
        
        if connectedPeer != nil {
            fatalError("Already connected to a peer.")
        }
        
        if !sharedTokenWithPeer {
            shareMyDiscoveryToken(token: myToken)
        }
        
        connectedPeer = peer
        peerDisplayName = peer.displayName
    }
    
    func disconnectedFromPeer(peer: MCPeerID) {
        if connectedPeer == peer {
            connectedPeer = nil
            sharedTokenWithPeer = false
        }
    }
    
    func dataReceivedHandler(data: Data, peer: MCPeerID) {
        if let discoveryToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) {
            peerDidShareDiscoveryToken(peer: peer, token: discoveryToken)
        }
        
        receivedText = String(data: data, encoding: .utf8)
    }
    
    func shareMyDiscoveryToken(token: NIDiscoveryToken) {
        guard let encodedData = try?  NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
            fatalError("Unexpectedly failed to encode discovery token.")
        }
        
        mpc?.sendDataToAllPeers(data: encodedData)
        sharedTokenWithPeer = true
    }
    
    func peerDidShareDiscoveryToken(peer: MCPeerID, token: NIDiscoveryToken) {
        if connectedPeer != peer {
            fatalError("Received token from unexpected peer.")
        }
        // Create a configuration.
        peerDiscoveryToken = token
        
        let config = NINearbyPeerConfiguration(peerToken: token)
        
        // Run the session.
        session?.run(config)
    }
    
    // MARK: - Visualizations
    func isNearby(_ distance: Float) -> Bool {
        return distance < nearbyDistanceThreshold
    }
    
    func isPointingAt(_ angleRad: Float) -> Bool {
        // Consider the range -15 to +15 to be "pointing at".
        return abs(angleRad.radiansToDegrees) <= 15
    }
    
    func getDistanceDirectionState(from nearbyObject: NINearbyObject) -> DistanceDirectionState {
        if nearbyObject.distance == nil && nearbyObject.direction == nil {
            return .unknown
        }
        
        let isNearby = nearbyObject.distance.map(isNearby(_:)) ?? false
        let directionAvailable = nearbyObject.direction != nil
        
        if isNearby && directionAvailable {
            return .closeUpInFOV
        }
        
        if !isNearby && directionAvailable {
            return .notCloseUpInFOV
        }
        
        return .outOfFOV
    }
}

// MARK: - `NISessionDelegate`.
extension NearbyInteractionManager: NISessionDelegate {
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        print("세션1")
        guard let peerToken = peerDiscoveryToken else {
            fatalError("don't have peer token")
        }

        // Find the right peer.
        let peerObj = nearbyObjects.first { (obj) -> Bool in
            return obj.discoveryToken == peerToken
        }

        guard let nearbyObjectUpdate = peerObj else {
            return
        }
    }
    
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        print("세션2")
        guard let peerToken = peerDiscoveryToken else {
            fatalError("don't have peer token")
        }
        // Find the right peer.
        let peerObj = nearbyObjects.first { (obj) -> Bool in
            return obj.discoveryToken == peerToken
        }

        if peerObj == nil {
            return
        }

        currentDistanceDirectionState = .unknown

        switch reason {
        case .peerEnded:
            // The peer token is no longer valid.
            peerDiscoveryToken = nil
            
            // The peer stopped communicating, so invalidate the session because
            // it's finished.
            session.invalidate()
            
            print("peerEnded")
            // Restart the sequence to see if the peer comes back.
            startup()
            
        case .timeout:
            print("timeout")
            // The peer timed out, but the session is valid.
            // If the configuration is valid, run the session again.
            if let config = session.configuration {
                session.run(config)
            }
        default:
            fatalError("Unknown and unhandled NINearbyObject.RemovalReason")
        }
    }
    
    func sessionWasSuspended(_ session: NISession) {
        print("세션3")
        currentDistanceDirectionState = .unknown
    }
    
    func sessionSuspensionEnded(_ session: NISession) {
        print("세션4")
        // Session suspension ended. The session can now be run again.
        if let config = self.session?.configuration {
            session.run(config)
        } else {
            // Create a valid configuration.
            startup()
        }
    }
    
    func session(_ session: NISession, didInvalidateWith error: Error) {
        print("세션5")
        currentDistanceDirectionState = .unknown

        // If the app lacks user approval for Nearby Interaction, present
        // an option to go to Settings where the user can update the access.
        if case NIError.userDidNotAllow = error {
            if #available(iOS 15.0, *) {
                // In iOS 15.0, Settings persists Nearby Interaction access.
                // Display the alert.
            } else {
                // Before iOS 15.0, ask the user to restart the app so the
                // framework can ask for Nearby Interaction access again.
            }

            return
        }
        // Recreate a valid session.
        startup()
    }
}
