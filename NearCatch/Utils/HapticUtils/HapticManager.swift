//
//  HapticManager.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/12.
//

import SwiftUI
import CoreMotion
import CoreHaptics

class HapticManager: ObservableObject {
    
    private var engine: CHHapticEngine!
    private var advancedPlayer: CHHapticAdvancedPatternPlayer!
    
    init() {
        self.createAndStartHapticEngine()
        self.initializeHaptic()
    }
    
    private func createAndStartHapticEngine() {
        do {
            engine = try CHHapticEngine()
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }
        
        engine.playsHapticsOnly = true
        
        // The stopped handler alerts you of engine stoppage.
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
        
        engine.resetHandler = {
            print("Reset Handler: Restarting the engine.")
            do {
                try self.engine.start()
                self.initializeHaptic()
            } catch {
                print("Failed to start the engine")
            }
        }
    }
    
    private func initializeHaptic() {
        let pattern = createPatternFromAHAP("NearCatchHeartbeat")!
        
        do {
            advancedPlayer = try engine.makeAdvancedPlayer(with: pattern)
            advancedPlayer?.loopEnabled = true
            advancedPlayer.playbackRate = 1
        } catch {
            print("error...")
        }
    }
    
    func startHaptic() {
        do {
            try engine.start()
            startPlayer(advancedPlayer)
        } catch {
            print("asdfasdf")
        }
    }
    
    func endHaptic() {
        do {
            try advancedPlayer.stop(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error stopping the continuous haptic player: \(error)")
        }
    }
    
    func updateHaptic(dist: Float?, matchingPercent: Float) {
        guard let dist = dist else { return }
        let intensityValue = linearInterpolation(alpha: dist, min: 0, max: 10)
        advancedPlayer.playbackRate = 1 + matchingPercent
        let intensityParameter = CHHapticDynamicParameter(parameterID: .hapticIntensityControl,
                                                          value: intensityValue,
                                                          relativeTime: 0)
        
        do {
            try advancedPlayer.sendParameters([intensityParameter], atTime: 0)
        } catch let error {
            print("Dynamic Parameter Error: \(error)")
        }
    }
    
    private func linearInterpolation(alpha: Float, min: Float, max: Float) -> Float {
        return alpha / (max - min)
    }
    
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
