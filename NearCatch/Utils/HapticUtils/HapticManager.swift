//
//  HapticManager.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/12.
//

import SwiftUI
import CoreMotion
import CoreHaptics

class HapticManager {
    
    private var engine: CHHapticEngine?
    // 'Advanced' PatternPlayer만 재생 컨트롤(멈춤, 반복재생, 뒤로가기 ...) 등이 가능함
    private var advancedPlayer: CHHapticAdvancedPatternPlayer?
    
    init() {
        self.createAndStartHapticEngine()
        self.initializeHaptic()
        self.startHaptic()
    }
    
    // 햅틱 엔진 생성
    private func createAndStartHapticEngine() {
        do {
            engine = try CHHapticEngine()
        } catch let error {
            print(error.localizedDescription)
        }
        
        guard let engine = engine else {
            return
        }
        
        // 햅틱 엔진 오직 햅틱만 ( 원래는 소리도 같이 넣는 게 정석 )
        engine.playsHapticsOnly = true
        
        // 엔진이 멈췄을 때 실행할 핸들러 지정
        engine.stoppedHandler = { reason in
            print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt:
                print("Audio session interrupt")
            case .applicationSuspended:
                print("Application suspended")
            case .idleTimeout:
                print("Idle timeout")
            case .systemError:
                print("System error")
            case .notifyWhenFinished:
                print("Playback finished")
            case .gameControllerDisconnect:
                print("Controller disconnected.")
            case .engineDestroyed:
                print("Engine destroyed.")
            @unknown default:
                print("Unknown error")
            }
        }
        
        // 엔진이 리셋되었을 대 실행할 핸들러 지정
        engine.resetHandler = {
            print("Reset Handler: Restarting the engine.")
            do {
                try self.engine?.start()
                self.initializeHaptic()
            } catch {
                print("Failed to start the engine")
            }
        }
    }
    
    // 햅틱 초기화하기
    private func initializeHaptic() {
        let pattern = createPatternFromAHAP("NearCatchHeartbeat")!
        
        do {
            advancedPlayer = try engine?.makeAdvancedPlayer(with: pattern)
            advancedPlayer?.loopEnabled = true
            advancedPlayer?.playbackRate = 1
        } catch {
            print("error...")
        }
    }
    
    // 햅틱 시작
    func startHaptic() {
        guard let advancedPlayer = advancedPlayer else { return }

        do {
            try engine?.start()
            startPlayer(advancedPlayer)
            
            // 햅틱을 미리 시작해두고 NISession이 생성될 때 반응하기 위해 일단 intensity를 0으로 두어 햅틱이 안느껴지도록 함
            let intensityParameter = CHHapticDynamicParameter(parameterID: .hapticIntensityControl,
                                                              value: 0,
                                                              relativeTime: 0)
            try advancedPlayer.sendParameters([intensityParameter], atTime: 0)
        } catch {
            print("asdfasdf")
        }
    }
    
    // 햅틱 종료
    func endHaptic() {
        guard let advancedPlayer = advancedPlayer else { return }
        
        do {
            try advancedPlayer.stop(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error stopping the continuous haptic player: \(error)")
        }
    }
    
    // 진동 속도, 세기 기준은 일단 임의로 지정함.
    func updateHaptic(dist: Float?, matchingPercent: Int) {
        guard let advancedPlayer = advancedPlayer else { return }
        guard let dist = dist else { return }
        // 최대 9mm 상정하고 0~1사이의 값 만든 후 hapticIntensityControl의 최대값인 1에서 빼주는 식으로 진동 세기 구현
        let intensityValue = dist / 9
        // 배속이 최대 3배속까지 안어색한 거같아서 매칭 최대 개수 10개시 3배속이 되도록 진동 속도 구현
        advancedPlayer.playbackRate = 1 + Float(matchingPercent) / 5
        let intensityParameter = CHHapticDynamicParameter(parameterID: .hapticIntensityControl,
                                                          value: 1 - intensityValue,
                                                          relativeTime: 0)
        
        do {
            try advancedPlayer.sendParameters([intensityParameter], atTime: 0)
        } catch let error {
            print("Dynamic Parameter Error: \(error)")
        }
    }
    
    // AHAP( Apple Haptic and Audio Pattern ) 햅틱을 JSON 형식으로 표현할 파일 -> 심장소리
    // 해당 AHAP 파일을 불러옴
    private func createPatternFromAHAP(_ filename: String) -> CHHapticPattern? {
        let patternURL = Bundle.main.url(forResource: filename, withExtension: "ahap")!
        
        do {
            let patternJSONData = try Data(contentsOf: patternURL, options: [])
            
            let dict = try JSONSerialization.jsonObject(with: patternJSONData, options: [])
            
            if let patternDict = dict as? [CHHapticPattern.Key: Any] {
                return try CHHapticPattern(dictionary: patternDict)
            }
        } catch let error {
            print("Error creating haptic pattern: \(error)")
        }
        return nil
    }
    
    // HapticPattern을 틀어줄 Player 객체 생성 및 플레이
    private func startPlayer(_ player: CHHapticPatternPlayer) {
        do {
            print("start")
            try player.start(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error starting haptic player: \(error)")
        }
    }
    
    private func stopPlayer(_ player: CHHapticPatternPlayer) {
        do {
            try player.stop(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error stopping haptic player: \(error)")
        }
    }
}
