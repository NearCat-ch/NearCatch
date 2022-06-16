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
                        .padding()
                    
                    if state == .ready {
                        LottieView(jsonName: "NearCatStanding")
                            .offset(y: 10)
                    } else {
                        LottieView(jsonName: "Star", loopMode: .loop)
                    }
                                
                    Image("img_bubble_197px")
                }
                .frame(width: 220, height: 220)
            }
            .buttonStyle(HomeMainButtonStyle())
        }
        .offset(y: -120)
    }
}

struct HomeMainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
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

