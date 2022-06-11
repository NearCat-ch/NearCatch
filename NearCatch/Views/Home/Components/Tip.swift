//
//  TipView.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/09.
//

import SwiftUI

struct Tip<InnerView>: View where InnerView: View {
    
    var content: () -> InnerView
    
    init(@ViewBuilder content: @escaping () -> InnerView) {
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            content()
        }
        .font(.body)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.ThirdColor)
                .overlay(alignment: .topLeading) {
                    Image("img_tip")
                        .offset(y: -28)
                }
        )
    }
}

struct TipView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            Tip {
                VStack {
                    Text("Tip 니어캣과 함께 주변을 돌아다녀 보세요".partialColor(["Tip", "니어캣"], .PrimaryColor))
                    Text("니어캣이 진동으로 인연의 별을 알려드릴 거에요".partialColor(["니어캣"], .PrimaryColor))
                }
                .font(.custom("온글잎 의연체", size: 28))
                .frame(maxWidth: .infinity)
            }
            
            Tip {
                Text("Tip 스마트폰을 서로 가까이 가져가 보세요\n공통된 관심사를 가지고 대화를 이어나가 보세요!".partialColor(["Tip"], .PrimaryColor))
                    .font(.custom("온글잎 의연체", size: 28))
                    .frame(maxWidth: .infinity)
            }
            
            Tip {
                VStack(spacing: 12) {
                    Text("NO. 권한을 허용하지 않으면\n니어캐치 앱 사용이 불가능해요!!\n".partialColor(["NO."], .PrimaryColor))
                    
                    Text("1. 설정에서 개인 정보 보호에 들어갑니다.")
                    Text("2. 근접 상호 작용 항목으로 들어갑니다.")
                    Text("3.니어캐치 앱의 권한을 허용해주세요")
                        .padding(.bottom, 28)
                    
                    Rectangle()
                        .frame(height: 200)
                }
                .font(.custom("온글잎 의연체", size: 28))
                .frame(maxWidth: .infinity)
            }
        }
        .previewLayout(.fixed(width: 400, height: 1000))
        .preferredColorScheme(.dark)
    }
}
