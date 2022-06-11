//
//  Home - Action:Rejection.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/11.
//

import SwiftUI

struct PermissionCheckView: View {
    var body: some View {
        ZStack {
            Image("img_background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
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
                
                Button {
                    print("설정 바로가게 해주는 코드")
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.PrimaryColor)
                            .frame(maxWidth: .infinity).frame(height: 50)
                        
                        Text("설정 바로가기")
                            .foregroundColor(.black)
                            .font(.custom("온글잎 의연체", size: 28))
                    }
                }
                
            }
            .padding(.horizontal, 20)
        }
        .preferredColorScheme(.dark)
    }
}

struct Home___Action_Rejection_Previews: PreviewProvider {
    static var previews: some View {
        PermissionCheckView()
    }
}
