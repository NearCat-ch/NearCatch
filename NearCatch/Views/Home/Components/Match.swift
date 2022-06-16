//
//  MatchView.swift
//  NearCatch
//
//  Created by Wonhyuk Choi on 2022/06/16.
//

import SwiftUI

struct Match: View {
    
    var body: some View {
        ZStack {
            VStack(spacing: 25) {
                Text("다음 주제로 대화해보세요!".partialColor(["다음 주제로"], .PrimaryColor))
                    .font(.custom("온글잎 의연체", size: 34))
                    ProfilePicture(imageData: Data())
                        .frame(width: 120, height: 120)
                
                Text("우리들의 공통점")
                    .font(.custom("온글잎 의연체", size: 22))
                
                Keywords()
            }
            LottieView(jsonName: "Fireworks")
                .frame(height: 400)
        }
        .padding()
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        Match()
            .preferredColorScheme(.dark)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.ThirdColor)
            )
            .previewLayout(.sizeThatFits)
    }
}
