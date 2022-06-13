//
//  HomeMainButton.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/09.
//

import SwiftUI

struct HomeMainButton: View {
    
    @Binding var state: GameState
    var action: () -> Void
    
    init(state: Binding<GameState>, action: @escaping () -> Void) {
        self._state = state
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: -54) {
            
            NearCat(state: $state)
            
            Button {
                action()
            } label: {
                ZStack {
                    Circle()
                        .strokeBorder(Color(.darkGray))
                        .background(
                            Circle().fill(.white.opacity(0.5))
                        )
                    
                    Circle()
                        .fill(.white)
                        .padding(8)
                    
                    Image("img_space")
                        .resizable()
                        .frame(width: 190, height: 190)
                    
                    if state == .ready {
                        Image("img_magnifying")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 66)
                    } else {
                        LottieView(jsonName: "Heart", loopMode: .loop)
//                        Image("img_stars")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 93, height: 93)
                    }
                                
                    Image("img_bubble_197px")
                }
                .frame(width: 220, height: 220)
            }
        }
    }
}

struct HomeMainButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 40) {
            HomeMainButton(state: .constant(.ready)) { }
            
            HomeMainButton(state: .constant(.finding)) { }
            
            HomeMainButton(state: .constant(.found)) { }
        }
        .padding(50)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}

