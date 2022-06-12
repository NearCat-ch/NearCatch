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
    
    init() {
        self.createAndStartHapticEngine()
        self.createContinuousHapticPlayer()
    }
    
    private var engine: CHHapticEngine!
    private var continuousPlayer: CHHapticAdvancedPatternPlayer!
    
    private let initialIntensity: Float = 1.0
    private let initialSharpness: Float = 0.5
    
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
                self.createContinuousHapticPlayer()
                
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
    
    func createContinuousHapticPlayer() {
        // Create an intensity parameter:
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                               value: initialIntensity)
        
        // Create a sharpness parameter:
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                               value: initialSharpness)
        
        // Create a continuous event with a long duration from the parameters.
        let continuousEvent = CHHapticEvent(eventType: .hapticContinuous,
                                            parameters: [intensity, sharpness],
                                            relativeTime: 0,
                                            duration: 100)
        
        do {
            // Create a pattern from the continuous haptic event.
            let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])
            
            // Create a player from the continuous haptic pattern.
            continuousPlayer = try engine.makeAdvancedPlayer(with: pattern)
            
        } catch let error {
            print("Pattern Player Creation Error: \(error)")
        }
    }
    
    func changeHaptic(yaw: Float, pitch: Float) {
        // The intensity should be highest at the top, opposite of the iOS y-axis direction, so subtract.
        //        let dynamicIntensity: Float = 1 - Float(normalizedLocation.y)
        
        // Dynamic parameters range from -0.5 to 0.5 to map the final sharpness to the [0,1] range.
        //        let dynamicSharpness: Float = Float(normalizedLocation.x) - 0.5
        
        // Create dynamic parameters for the updated intensity & sharpness.
        let intensityParameter = CHHapticDynamicParameter(parameterID: .hapticIntensityControl,
                                                          value: min(yaw * yaw + pitch * pitch, 0.2),
                                                          relativeTime: 0)
        
        let sharpnessParameter = CHHapticDynamicParameter(parameterID: .hapticSharpnessControl,
                                                          value: 0.1,
                                                          relativeTime: 0)
        
        // Send dynamic parameters to the haptic player.
        do {
            try continuousPlayer.sendParameters([intensityParameter, sharpnessParameter],
                                                atTime: 0)
        } catch let error {
            print("Dynamic Parameter Error: \(error)")
        }
        
        do {
            // Begin playing continuous pattern.
            try continuousPlayer.start(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error starting the continuous haptic player: \(error)")
        }
    }
    
    func endHaptic() {
        do {
            try continuousPlayer.stop(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error stopping the continuous haptic player: \(error)")
        }
    }
}
