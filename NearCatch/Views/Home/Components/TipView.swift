//
//  TipView.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/09.
//

import SwiftUI

struct TipView<InnerView>: View where InnerView: View {
    
    var content: () -> InnerView
    
    init(@ViewBuilder content: @escaping () -> InnerView) {
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Tip")
                .foregroundColor(Color(hex: 0xFFEC6C))
            content()
        }
        .font(.body)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(hex: 0x00254B))
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
            TipView {
                Text("니어캣과 함께 주변을 돌아다녀 보세요\n니어캣이 진동으로 인연의 별을 알려드릴 거에요")
                    .frame(maxWidth: .infinity)
            }
            
            TipView {
                VStack(spacing: 12) {
                    Text("NO. 권한을 허용하지 않으면\n니어캐치 앱 사용이 불가능해요!!")
                        .padding(.bottom, 28)
                    
                    Text("1. 설정에서 개인 정보 보호에 들어갑니다.")
                    Text("2. 근접 상호 작용 항목으로 들어갑니다.")
                    Text("3.니어캐치 앱의 권한을 허용해주세요")
                        .padding(.bottom, 28)
                    
                    Rectangle()
                        .frame(height: 200)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(30)
        .previewLayout(.fixed(width: 450, height: 800))
        .preferredColorScheme(.dark)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
