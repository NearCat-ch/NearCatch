//
//  SearchView.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/11.
//

import SwiftUI

struct SearchView: View {
    
    var name: String
    @State private var state = GameState.finding
    
    private var guideText: AttributedString {
        switch state {
        case .ready:
            return ""
        case .finding:
            return "\"니어캣이 \(name)님의\n인연의 별을 찾고 있어요!\"".partialColor(["니어캣"], .PrimaryColor)
        case .found:
            return "\"니어캣이 \(name)님의\n인연의 별을 찾았어요!\"".partialColor(["니어캣"], .PrimaryColor)
        }
    }
    
    var body: some View {
        ZStack {
            Image("img_background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(guideText)
                    .multilineTextAlignment(.center)
                    .font(.custom("온글잎 의연체", size: 28))
                    .overlay(alignment: .top) {
                        Image("img_shooting")
                            .offset(x: -80, y: -40)
                    }
                
                HomeMainButton(state: $state) {
                    print("취소")
                }
                
                if state == .finding {
                    StarBubble(count: 2)
                } else if state == .found {
                    HeartBubble()
                }
                
                Tip {
                    Text("Tip 스마트폰을 서로 가까이 가져가 보세요\n공통된 관심사를 가지고 대화를 이어나가 보세요!".partialColor(["Tip"], .PrimaryColor))
                        .font(.custom("온글잎 의연체", size: 28))
                        .frame(maxWidth: .infinity)
                }
                .padding([.top, .horizontal], 20)
                //MARK: 상태 변환 테스트
                .onTapGesture {
                    state = state == .found ? .finding : .found
                }
            }
            
        }
        .preferredColorScheme(.dark)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(name: "아이유")
    }
}
