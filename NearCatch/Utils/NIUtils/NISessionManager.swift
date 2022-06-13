/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An object that manages the interaction session.
*/

import Foundation
import NearbyInteraction
import MultipeerConnectivity
import UIKit

class NISessionManager: NSObject, ObservableObject {
    var session: NISession?
    var peerDiscoveryToken: NIDiscoveryToken?
    var mpc: MPCSession?

    @Published var connectedPeer: MCPeerID?
    @Published var sharedTokenWithPeer = false
    @Published var latestNearbyObject: NINearbyObject?
    @Published var peersCnt: Int = 0

    override init() {
        super.init()
//        startup()
    }

    deinit {
        session?.invalidate()
        mpc?.invalidate()
    }
    
    func start() {
        startup()
    }
    
    func stop() {
        session?.invalidate()
        mpc?.invalidate()
        connectedPeer = nil
        sharedTokenWithPeer = false
        latestNearbyObject = nil
        peersCnt = 0
        mpc = nil
        peerDiscoveryToken = nil
        session = nil
    }

    func startup() {
        // NISession 생성
        session = NISession()

        // delegate 지정
        session?.delegate = self

        // Because the session is new, reset the token-shared flag.
        sharedTokenWithPeer = false

        // If a connected peer exists, share the discovery token, if needed.
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
                return
                //                fatalError("Unable to get self discovery token, is this session invalidated?")
            }
        } else {
            startupMPC()
        }
    }

    // MARK: - MPC를 사용하여 디스커버리 토큰 공유

    func startupMPC() {
        if mpc == nil {
            // Prevent Simulator from finding devices.
            #if targetEnvironment(simulator)
            mpc = MPCSession(service: "nearcatch", identity: "com.2pm.NearCatch")
            #else
            mpc = MPCSession(service: "nearcatch", identity: "com.2pm.NearCatch")
            #endif
            mpc?.delegate = self
            mpc?.peerConnectedHandler = connectedToPeer
            mpc?.peerDataHandler = dataReceivedHandler
            mpc?.peerDisconnectedHandler = disconnectedFromPeer
        }
        mpc?.invalidate()
        mpc?.start()
    }

    func connectedToPeer(peer: MCPeerID) {
        guard let myToken = session?.discoveryToken else {
            fatalError("Unexpectedly failed to initialize nearby interaction session.")
        }

        if !sharedTokenWithPeer {
            shareMyDiscoveryToken(token: myToken)
        }

        connectedPeer = peer
    }

    func disconnectedFromPeer(peer: MCPeerID) {
        if connectedPeer == peer {
            connectedPeer = nil
            sharedTokenWithPeer = false
        }
    }

    // TODO: 데이터(프로필 정보) 리시빙 가능하도록 수정
    func dataReceivedHandler(data: Data, peer: MCPeerID) {
        guard let discoveryToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else {
            fatalError("Unexpectedly failed to decode discovery token.")
        }
        peerDidShareDiscoveryToken(peer: peer, token: discoveryToken)
    }

    func shareMyDiscoveryToken(token: NIDiscoveryToken) {
        guard let encodedData = try?  NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true) else {
            fatalError("Unexpectedly failed to encode discovery token.")
        }
        mpc?.sendDataToAllPeers(data: encodedData)
        sharedTokenWithPeer = true
    }

    func peerDidShareDiscoveryToken(peer: MCPeerID, token: NIDiscoveryToken) {
        guard connectedPeer == peer else { return }

        // Create a configuration.
        peerDiscoveryToken = token

        let config = NINearbyPeerConfiguration(peerToken: token)

        // Run the session.
        session?.run(config)
    }
}

// MARK: - `NISessionDelegate`.
extension NISessionManager: NISessionDelegate {
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        guard let peerToken = peerDiscoveryToken else {
            fatalError("don't have peer token")
        }
        
        print("세션1")
        
        // TODO: 가장 가까운 피어 혹은 관심사가 비슷한 피어 찾는 로직으로 구성
        // Find the right peer.
        let peerObj = nearbyObjects.first { (obj) -> Bool in
            return obj.discoveryToken == peerToken
        }

        guard let nearbyObjectUpdate = peerObj else {
            return
        }

        // Update the latest nearby object.
        latestNearbyObject = nearbyObjectUpdate
    }
    
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        guard let peerToken = peerDiscoveryToken else {
            fatalError("don't have peer token")
        }
        
        print("세션2")
        
        // Find the right peer.
        let peerObj = nearbyObjects.first { (obj) -> Bool in
            return obj.discoveryToken == peerToken
        }
        
        if peerObj == nil {
            return
        }
        
        switch reason {
        case .peerEnded:
            print("피어엔드")
            // The peer token is no longer valid.
            peerDiscoveryToken = nil
            
            // The peer stopped communicating, so invalidate the session because
            // it's finished.
            session.invalidate()
            
            // Restart the sequence to see if the peer comes back.
            startup()
        case .timeout:
            print("타임아웃")
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
    }

    func sessionSuspensionEnded(_ session: NISession) {
        // Session suspension ends. You can run the session again.
        if let config = self.session?.configuration {
            session.run(config)
        } else {
            // Create a valid configuration.
            startup()
        }
    }

    func session(_ session: NISession, didInvalidateWith error: Error) {
        // If the app lacks user approval for Nearby Interaction, present
        // an option to go to Settings where the user can update the access.
        if case NIError.userDidNotAllow = error {
            return
        }

        // Recreate a valid session in other failure cases.
        startup()
    }
}

extension NISessionManager: MultipeerConnectivityManagerDelegate {
    func connectedDevicesChanged(devices: [String]) {
        peersCnt = devices.count
    }
}
