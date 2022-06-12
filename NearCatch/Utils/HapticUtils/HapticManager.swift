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
    
    private let initialIntensity: Float = 1.0
    private let initialSharpness: Float = 0.5
    
    init() {
        self.createAndStartHapticEngine()
        self.initializeHaptic()
    }
    
    func createAndStartHapticEngine() {
        do {
            engine = try CHHapticEngine()
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }
        
        // Mute audio to reduce latency for collision haptics.
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
        
        // The reset handler provides an opportunity to restart the engine.
        engine.resetHandler = {
            
            print("Reset Handler: Restarting the engine.")
            
            do {
                // Try restarting the engine.
                try self.engine.start()
                
                // Recreate the continuous player.
                self.initializeHaptic()
                
            } catch {
                print("Failed to start the engine")
            }
        }
        
        // Start the haptic engine for the first time.
        do {
            try self.engine.start()
        } catch {
            print("Failed to start the engine: \(error)")
        }
    }
    
    func updateHaptic(dist: Float?, matchingCount: Int) {
//        guard let dist = dist else { return }

        let intensityValue = linearInterpolation(alpha: 0.5, min: 0.05, max: 1)
        print(intensityValue)
        let intensityParameter = CHHapticDynamicParameter(parameterID: .hapticIntensityControl,
                                                          value: 0,
                                                          relativeTime: 0)
        
        do {
            try advancedPlayer.sendParameters([intensityParameter], atTime: 0)
        } catch let error {
            print("Dynamic Parameter Error: \(error)")
        }
        
    }
    
    private func linearInterpolation(alpha: Float, min: Float, max: Float) -> Float {
        return min + alpha * (max - min)
    }
    
    func initializeHaptic() {
        let pattern = createPatternFromAHAP("NearCatchHeartbeat")!
        
        do {
            advancedPlayer = try? engine.makeAdvancedPlayer(with: pattern)
            advancedPlayer?.loopEnabled = true
            startPlayer(advancedPlayer)
        } catch {
            print("erro...")
        }
    }
    
    private func createPatternFromAHAP(_ filename: String) -> CHHapticPattern? {
        // Get the URL for the pattern in the app bundle.
        let patternURL = Bundle.main.url(forResource: filename, withExtension: "ahap")!
        
        do {
//            try engine.playPattern(from: patternURL)
            // Read JSON data from the URL.
            let patternJSONData = try Data(contentsOf: patternURL, options: [])
            
            // Create a dictionary from the JSON data.
            let dict = try JSONSerialization.jsonObject(with: patternJSONData, options: [])
            
            if let patternDict = dict as? [CHHapticPattern.Key: Any] {
                // Create a pattern from the dictionary.
                return try CHHapticPattern(dictionary: patternDict)
            }
        } catch let error {
            print("Error creating haptic pattern: \(error)")
        }
        return nil
    }
    
    func endHaptic() {
        do {
            try advancedPlayer.stop(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error stopping the continuous haptic player: \(error)")
        }
    }
    
    func startPlayer(_ player: CHHapticPatternPlayer) {
//        guard supportsHaptics else { return }
        do {
//            try startHapticEngineIfNecessary()
            try player.start(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error starting haptic player: \(error)")
        }
    }
    
    func stopPlayer(_ player: CHHapticPatternPlayer) {
//        guard supportsHaptics else { return }
        
        do {
//            try startHapticEngineIfNecessary()
            try player.stop(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error stopping haptic player: \(error)")
        }
    }
}
