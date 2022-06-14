/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An object that manages the interaction session.
*/

import Foundation
import NearbyInteraction
import MultipeerConnectivity
import UIKit

class TranData: NSObject, NSCoding {
    let token : NIDiscoveryToken
    let isMatched : Bool
    let keywords : [Int]
    
    init(token : NIDiscoveryToken, isMatched : Bool = false, keywords : [Int] = []) {
        self.token = token
        self.isMatched = isMatched
        self.keywords = keywords
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.token, forKey: "token")
        coder.encode(self.isMatched, forKey: "isMatched")
        coder.encode(self.keywords, forKey: "keywords")
    }
    
    required init?(coder: NSCoder) {
        self.token = coder.decodeObject(forKey: "token") as! NIDiscoveryToken
        self.isMatched = coder.decodeBool(forKey: "isMatched")
        self.keywords = coder.decodeObject(forKey: "keywords") as! [Int]
    }
}

class NISessionManager: NSObject, ObservableObject {

    @Published var connectedPeers = [MCPeerID]()
    @Published var matechedObject: NINearbyObject? // TODO: 매치할 오브젝트 저장
    @Published var peersCnt: Int = 0
    @Published var gameState : GameState = .ready
    @Published var isBumped: Bool = false

    var mpc: MPCSession?
    var sessions = [MCPeerID:NISession]()
    var peerTokensMapping = [NIDiscoveryToken:MCPeerID]()
    
    let nearbyDistanceThreshold: Float = 0.2 // 범프 한계 거리
    
    let myKeywords = [1, 2, 3, 4, 5] // 하드 코딩

    @Published var isPermissionDenied = false

    override init() {
        super.init()
    }

    deinit {
        sessions.removeAll()
        mpc?.invalidate()
    }
    
    func start() {
        startup()
    }
    
    func stop() {
        for (_, session) in sessions {
            session.invalidate()
        }
        mpc?.invalidate()
        mpc = nil
        connectedPeers.removeAll()
        sessions.removeAll()
        peerTokensMapping.removeAll()
        peersCnt = 0
    }

    func startup() {
        // mpc 재실행
        mpc?.invalidate()
        mpc = nil
        connectedPeers.removeAll()

        // 1. MPC 작동
        startupMPC()
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
    
    // MPC peerConnectedHandeler에 의해 피어 연결
    // 2. 피어 연결 (NI 디스커버리 토큰을 공유)
    func connectedToPeer(peer: MCPeerID) {
        guard sessions[peer] == nil else { return }
        
        // 해당 피어의 NI Session 생성
        sessions[peer] = NISession()
        sessions[peer]?.delegate = self
        
        guard let myToken = sessions[peer]?.discoveryToken else {
            fatalError("Unexpectedly failed to initialize nearby interaction session.")
        }
        
        // 3. 연결된 피어 추가
        if !connectedPeers.contains(peer) {
            // 4. 나의 NI 디스커버리 토큰 공유
            shareMyDiscoveryToken(token: myToken, peer: peer)
            connectedPeers.append(peer)
        }
    }

    // MPC peerDisconnectedHander에 의해 피어 연결 해제
    func disconnectedFromPeer(peer: MCPeerID) {
        // 연결 해제시 연결된 피어 제거
        if connectedPeers.contains(peer) {
            connectedPeers = connectedPeers.filter { $0 != peer }
            sessions[peer] = nil
        }
    }
    
    // TODO: 데이터(프로필 정보) 리시빙 가능하도록 수정
    // MPC peerDataHandler에 의해 데이터 리시빙
    // 5. 상대 토큰 수신
    func dataReceivedHandler(data: Data, peer: MCPeerID) {
        guard let receivedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? TranData else {
            fatalError("Unexpectedly failed to decode discovery token.")
        }
        
        let discoveryToken = receivedData.token
        
        peerDidShareDiscoveryToken(peer: peer, token: discoveryToken)
    }

    func shareMyDiscoveryToken(token: NIDiscoveryToken, peer: MCPeerID) {
        let tranData = TranData(token: token)
        
        guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: tranData, requiringSecureCoding: false) else {
            fatalError("Unexpectedly failed to encode discovery token.")
        }
        
        mpc?.sendData(data: encodedData, peers: [peer], mode: .reliable)
    }

    func peerDidShareDiscoveryToken(peer: MCPeerID, token: NIDiscoveryToken) {
        guard connectedPeers.contains(peer) else { return }
        
        guard peerTokensMapping[token] == nil else { return }
        
        peerTokensMapping[token] = peer
        
        // 6. 피어토큰으로 NI 세션 설정
        let config = NINearbyPeerConfiguration(peerToken: token)
        
        // Run the session.
        // 7. NI 세션 시작
        sessions[peer]?.run(config)
    }
}

// MARK: - `NISessionDelegate`.
extension NISessionManager: NISessionDelegate {
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        // Find the right peer.
        let peerObj = nearbyObjects.first { (obj) -> Bool in
            return peerTokensMapping[obj.discoveryToken] != nil
        }

        guard let nearbyObjectUpdate = peerObj else { return }

        if getDistanceDirectionState(from: nearbyObjectUpdate) == .closeUpInFOV {
            isBumped = true
            gameState = .ready
            stop()
        }
    }
    
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) {
        // Find the right peer.
        let peerObj = nearbyObjects.first { (obj) -> Bool in
            return peerTokensMapping[obj.discoveryToken] != nil
        }
        
        if peerObj == nil {
            return
        }
        
        switch reason {
        case .peerEnded:
            guard let curMPCid = peerTokensMapping[peerObj!.discoveryToken] else { return }
            
            peerTokensMapping[peerObj!.discoveryToken] = nil
            
            // The peer stopped communicating, so invalidate the session because
            // it's finished.
            sessions[curMPCid]?.invalidate()
            sessions[curMPCid] = nil
            
            // Restart the sequence to see if the peer comes back.
            startup()
        case .timeout:
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
        startup()
    }

    func session(_ session: NISession, didInvalidateWith error: Error) {
        // If the app lacks user approval for Nearby Interaction, present
        // an option to go to Settings where the user can update the access.
        if case NIError.userDidNotAllow = error {
            isPermissionDenied = true
        }

        // Recreate a valid session in other failure cases.
        startup()
    }
}

// MARK: - `MultipeerConnectivityManagerDelegate`.
extension NISessionManager: MultipeerConnectivityManagerDelegate {
    func connectedDevicesChanged(devices: [String]) {
        peersCnt = devices.count
    }
}

// MARK: - 거리에 따라 반응 로직

extension NISessionManager {

    enum DistanceDirectionState {
        case closeUpInFOV, notCloseUpInFOV, outOfFOV, unknown
    }
    
    // 범프
    func isNearby(_ distance: Float) -> Bool {
        return distance < nearbyDistanceThreshold
    }
    
    func getDistanceDirectionState(from nearbyObject: NINearbyObject) -> DistanceDirectionState {
        if nearbyObject.distance == nil && nearbyObject.direction == nil {
            return .unknown
        }
        
        //        print(nearbyObject.distance!)
        
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

extension Data {
    func subdata(in range: ClosedRange<Index>) -> Data {
        return subdata(in: range.lowerBound ..< range.upperBound + 1)
    }
}
