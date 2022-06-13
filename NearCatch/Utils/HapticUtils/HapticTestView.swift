//
//  HapticTestView.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/12.
//

import SwiftUI

struct HapticTestView: View {
    
    @StateObject var hapticManager = HapticManager()
    
    // 테스트용
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    @State private var distance: Float = 10
    @State private var matchingPercent: Float = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("MatchingCount")
            Slider(value: $matchingPercent, in: 0...1)
            
            Spacer()
                .frame(height: 30)
            
            Text("Distance")
            Slider(value: $distance, in: 0...10)
            
            HStack {
                Button(role: .cancel) {
                    // 햅틱 종료
                    hapticManager.endHaptic()
                } label: {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                        
                        Text("멈춤")
                            .foregroundColor(.white)
                    }
                }
                
                Button(role: .destructive) {
                    // 햅틱 시작
                    hapticManager.startHaptic()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                        
                        Text("시작")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.top, 40)

        }
        .padding(.horizontal, 30)
        .onReceive(timer) { _ in
            // 거리 + 일치한 관심사 개수에 따라 햅틱 업데이트
            hapticManager.updateHaptic(dist: distance, matchingPercent: matchingPercent)
        }
    }
}

struct HapticTestView_Previews: PreviewProvider {
    static var previews: some View {
        HapticTestView()
    }
}

