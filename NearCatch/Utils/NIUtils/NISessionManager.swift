/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An object that manages the interaction session.
 
Edited by Wonhyuk Choi on 2022/06/09.
*/

import CoreBluetooth
import Foundation
import NearbyInteraction
import MultipeerConnectivity
import UIKit

class TokenData: NSObject, NSCoding {
    let token : NIDiscoveryToken
    let keywords : [Int]
    
    init(token: NIDiscoveryToken, keywords: [Int]) {
        self.token = token
        self.keywords = keywords
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.token, forKey: "token")
        coder.encode(self.keywords, forKey: "keywords")
    }
    
    required init?(coder: NSCoder) {
        self.token = coder.decodeObject(forKey: "token") as! NIDiscoveryToken
        self.keywords = coder.decodeObject(forKey: "keywords") as! [Int]
    }
}

class InfoData: NSObject, NSCoding {
    let keywords : [Int]
    let nickname : String
    let image : UIImage
    
    init(keywords: [Int], nickname: String, image: UIImage) {
        self.keywords = keywords
        self.nickname = nickname
        self.image = image
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.keywords, forKey: "keywords")
        coder.encode(self.nickname, forKey: "nickname")
        coder.encode(self.image, forKey: "image")
    }
    
    required init?(coder: NSCoder) {
        self.nickname = coder.decodeObject(forKey: "nickname") as! String
        self.keywords = coder.decodeObject(forKey: "keywords") as! [Int]
        self.image = coder.decodeObject(forKey: "image") as! UIImage
    }
}

class NISessionManager: NSObject, ObservableObject {
    
    @Published var connectedPeers = [UUID]() { // 상호 연결된 피어들
        didSet {
            peersCnt = connectedPeers.count
        }
    }
    @Published var matchedPeer: TokenData? // 매치된 피어
    @Published var peersCnt: Int = 0
    @Published var gameState : GameState = .ready
    @Published var isBumped: Bool = false
    @Published var isPermissionDenied = false
    
    var cb: CBSession?
    var sessions = [UUID:NISession]()
    var peerTokensMapping = [NIDiscoveryToken:CBCentral]()
    
    private let nearbyDistanceThreshold: Float = 0.08 // 범프 한계 거리
    private let hapticManager = HapticManager()
    
    // 나의 정보
    @Published var myNickname : String = ""
    @Published var myKeywords : [Int] = []
    @Published var myPicture : UIImage?
    
    // 범프된 상대 정보
    @Published var bumpedName = ""
    @Published var bumpedKeywords : [Int] = []
    @Published var bumpedImage : UIImage?
    
    override init() {
        super.init()
    }

    deinit {
        cb?.invalidate()
    }
    
    func start() {
        startup()
        
        myNickname = CoreDataManager.coreDM.readAllProfile()[0].nickname ?? ""
        myKeywords = CoreDataManager.coreDM.readKeyword()[0].favorite
        myPicture = CoreDataManager.coreDM.readAllPicture()[0].content
    }
    
    func stop() {
        for (_, session) in sessions {
            session.invalidate()
        }
        connectedPeers.removeAll()
        sessions.removeAll()
        peerTokensMapping.removeAll()
        matchedPeer = nil
        peersCnt = 0
        hapticManager.endHaptic()
        if(!isBumped) {
            cb?.invalidate()
            cb = nil
        }
    }

    func startup() {
        // cb 재실행
        cb?.invalidate()
        cb = nil
        connectedPeers.removeAll()

        // 1. CB 작동
        startupCB()
    }

    // MARK: - CB를 사용하여 디스커버리 토큰 공유
    
    func startupCB() {
        if cb == nil {
            cb = CBSession()
            cb?.peerConnectedHandler = connectedToPeer
            cb?.peerDisconnectedHandler = disconnectedFromPeer
            cb?.peerDataFromCentralHandler = tokenDataReceivedHandler
            cb?.peerDataFromPeripheralHandler = infoDataReceivedHandler
        }
        cb?.invalidate()
        cb?.start()
    }
    
    // CB peerConnectedHandeler에 의해 피어 연결
    // 2. 피어 연결 (NI 디스커버리 토큰을 공유)
    func connectedToPeer(peer: CBPeripheral) {
        let puid = peer.identifier
        guard sessions[puid] == nil else { return }
        
        // 해당 피어의 NI Session 생성
        sessions[puid] = NISession()
        sessions[puid]?.delegate = self
        
        guard let myToken = sessions[puid]?.discoveryToken else { return }
        
        // 3. 연결된 피어 추가
        if !connectedPeers.contains(puid) {
            // 4. 나의 NI 디스커버리 토큰 공유
            shareMyTokenData(token: myToken, peer: peer)
            connectedPeers.append(puid)
        }
    }
    
    // CB peerDisconnectedHander에 의해 피어 연결 해제
    func disconnectedFromPeer(peer: CBPeripheral) {
        let puid = peer.identifier
        if connectedPeers.contains(puid) {
            connectedPeers = connectedPeers.filter { $0 != puid }
            sessions[puid]?.invalidate()
            sessions[puid] = nil
        }
        
        guard let matchedToken = matchedPeer?.token else { return }
        if peerTokensMapping[matchedToken]?.identifier == puid {
            matchedPeer = nil
            hapticManager.endHaptic()
            if !isBumped {
                gameState = .finding
            }
        }
    }
    
    // 5. 상대 토큰 수신
    // CB peerDataFromCentralHandler에 의해 토큰 데이터 리시빙 (Central -> Peripheral)
    func tokenDataReceivedHandler(data: Data, peer: CBCentral) {
        guard let receivedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? TokenData else { return }
        let discoveryToken = receivedData.token
        peerDidShareDiscoveryToken(peer: peer, token: discoveryToken)
        
        // 3개 이상일 때만 매치
        if calMatchingKeywords(myKeywords, receivedData.keywords) > 2 {
            DispatchQueue.global(qos: .userInitiated).async {
                self.compareForCheckMatchedObject(receivedData)
            }
            hapticManager.startHaptic()
        }
    }
    
    // 상대 정보 수신
    // CB peerDataFromPeripheralHandler에 의해 정보 데이터 리시빙 (Peripheral -> Central)
    func infoDataReceivedHandler(data: Data, peer: CBPeripheral) {
        guard let receivedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? InfoData else { return }
        
        if !isBumped {
            isBumped = true
            bumpedName = receivedData.nickname
            bumpedKeywords = receivedData.keywords
            bumpedImage = receivedData.image
        }
        stop()
        gameState = .ready
    }

    func shareMyTokenData(token: NIDiscoveryToken, peer: CBPeripheral) {
        let tokenData = TokenData(token: token, keywords: myKeywords)
        
        guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: tokenData, requiringSecureCoding: false) else { return }
        cb?.sendDataToPeripheral(data: encodedData, peer: peer)
    }
    
    func shareMyInfoData(peer: CBCentral) {
        var resizedImage : UIImage = .add
        if let picture = myPicture {
            let size = CGSize(width: 50, height: 50)
            let renderer = UIGraphicsImageRenderer(size: size)
            resizedImage = renderer.image { context in
                picture.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
        }
        
        let infoData = InfoData(keywords: myKeywords, nickname: myNickname, image: resizedImage)
        
        guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: infoData, requiringSecureCoding: false) else { return }
        
        cb?.sendDataToCentral(data: encodedData, peer: peer)
    }
    
    func peerDidShareDiscoveryToken(peer: CBCentral, token: NIDiscoveryToken) {
        // 기존에 토큰을 가지고 있는 상대인데 재연결로 다시 수신받은 경우 session 종료 후 다시 시작
        if let ownedPeer = peerTokensMapping[token] {
            self.sessions[ownedPeer.identifier]?.invalidate()
            self.sessions[ownedPeer.identifier] = nil
            // 그 피어가 매치 상대일 경우 매치 상대 초기화
            if matchedPeer?.token == token {
                matchedPeer = nil
                hapticManager.endHaptic()
                if !isBumped {
                    gameState = .finding
                }
            }
        }
        
        peerTokensMapping[token] = peer
        
        let config = NINearbyPeerConfiguration(peerToken: token)
        sessions[peer.identifier]?.run(config)
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
        
        // 범프
        if isNearby(nearbyObjectUpdate.distance ?? 10) {
            guard let peerId = peerTokensMapping[nearbyObjectUpdate.discoveryToken] else { return }
            self.shareMyInfoData(peer: peerId)
        }
        
        // 매칭된 사람일 경우 진동 변화
        guard let peer = matchedPeer else { return }
        if nearbyObjectUpdate.discoveryToken == peer.token {
            hapticManager.updateHaptic(dist: nearbyObjectUpdate.distance ?? 10,
                                       matchingPercent: calMatchingKeywords(peer.keywords, myKeywords))
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
            guard let curPeer = peerTokensMapping[peerObj!.discoveryToken] else { return }
            
            peerTokensMapping[peerObj!.discoveryToken] = nil
            
            // The peer stopped communicating, so invalidate the session because
            // it's finished.
            sessions[curPeer.identifier]?.invalidate()
            sessions[curPeer.identifier] = nil
            
            // Restart the sequence to see if the peer comes back.
            startup()
        case .timeout:
            // The peer timed out, but the session is valid.
            // If the configuration is valid, run the session again.
            if let config = session.configuration {
                    session.run(config)
            }
        default:
            //            fatalError("Unknown and unhandled NINearbyObject.RemovalReason")
            return
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
    
    // 범프
    func isNearby(_ distance: Float) -> Bool {
        return distance < nearbyDistanceThreshold
    }
    
    // 매칭 상대 업데이트
    private func compareForCheckMatchedObject(_ data: TokenData) {
        
        guard matchedPeer != data else { return }
        
        if let nowTranData = matchedPeer {
            
            let withCurCnt : Int = calMatchingKeywords(myKeywords, nowTranData.keywords)
            let withNewCnt : Int = calMatchingKeywords(myKeywords, data.keywords)
            
            if withCurCnt < withNewCnt { matchedPeer = data }
            
        } else {
            matchedPeer = data
            if !isBumped { gameState = .found }
        }
        
    }
    
    private func calMatchingKeywords(_ first: [Int], _ second: [Int]) -> Int {
        let cnt = Set(first).intersection(second).count
        return cnt
    }
}
