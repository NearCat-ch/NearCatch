//
//  TipChange.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/17.
//

import SwiftUI

struct TipChange: View {
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State private var currentIndex = 0
    
    var body: some View {
        TabView (selection: $currentIndex){
            ForEach(0..<3) { num in
                if num == 0 {
                    Tip {
                        VStack {
                            Text("Tip 니어캣과 함께 주변을 돌아다녀 보세요".partialColor(["Tip", "니어캣"], .PrimaryColor))
                            Text("니어캣이 진동으로 인연의 별을 알려드릴 거에요".partialColor(["니어캣"], .PrimaryColor))
                        }
                        .font(.custom("온글잎 의연체", size: 28))
                        .frame(maxWidth: .infinity)
                    }
                }
                else if num == 1 {
                    Tip {
                        Text("Tip 스마트폰을 서로 가까이 가져가 보세요.\n왠지 두근거리는 느낌이 들지 않나요?".partialColor(["Tip"], .PrimaryColor))
                            .font(.custom("온글잎 의연체", size: 28))
                            .frame(maxWidth: .infinity)
                    }
                }
                else {
                    Tip {
                        Text("Tip 스마트폰의 뒷면을 서로 맞대보세요!\n 서로의 관심사를 확인할 수 있어요!".partialColor(["Tip"], .PrimaryColor))
                            .font(.custom("온글잎 의연체", size: 28))
                            .frame(maxWidth: .infinity)
                    }
                }
                    
            }
        }.preferredColorScheme(.dark)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .onReceive(timer, perform: { _ in
                withAnimation {
                    currentIndex = currentIndex < 2 ? currentIndex + 1 : 0
                }
            })
    }
}

struct TipChange_Previews: PreviewProvider {
    static var previews: some View {
        TipChange()
    }
}
