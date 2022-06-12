//
//  HapticTestView.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/12.
//

import SwiftUI

struct HapticTestView: View {
    
    @StateObject var niManager = NISessionManager()
    @StateObject var hapticManager = HapticManager()
    
    // 테스트용
    @State private var distance: Float = 0
    @State private var matchingCount = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Distance")
            Slider(value: $distance, in: 0...10)
        }
        .padding(.horizontal, 30)
         //실제 사용시
//        .onChange(of: niManager.latestNearbyObject) { object in
//            // matchingCount 프로퍼티 공통관심사 로직 확정되면 수정
//            hapticManager.updateHaptic(dist: object?.distance, matchingCount: 1)
//        }
        // 테스트용
        .onChange(of: distance) { dist in
            hapticManager.updateHaptic(dist: distance, matchingCount: matchingCount)
        }
    }
}

struct HapticTestView_Previews: PreviewProvider {
    static var previews: some View {
        HapticTestView()
    }
}

