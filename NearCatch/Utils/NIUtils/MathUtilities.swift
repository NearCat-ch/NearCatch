/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A math utility method to scale to a range based on a domain.
 
Edited by Wonhyuk Choi on 2022/06/09.
*/
import simd

extension Float {
    func scale(minRange: Float, maxRange: Float, minDomain: Float, maxDomain: Float) -> Float {
        return minDomain + (maxDomain - minDomain) * (max(minRange, min(self, maxRange)) - minRange) / (maxRange - minRange)
    }
}

extension FloatingPoint {
    // Converts degrees to radians.
    var degreesToRadians: Self { self * .pi / 180 }
    // Converts radians to degrees.
    var radiansToDegrees: Self { self * 180 / .pi }
}

// Provides the azimuth from an argument 3D directional.
func azimuth(from direction: simd_float3) -> Float {
    return asin(direction.x)
}

// Provides the elevation from the argument 3D directional.
func elevation(from direction: simd_float3) -> Float {
    return atan2(direction.z, direction.y) + .pi / 2
}
