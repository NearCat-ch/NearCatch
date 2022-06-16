//
//  MatchView.swift
//  NearCatch
//
//  Created by Wonhyuk Choi on 2022/06/16.
//

import SwiftUI

struct Match: View {
    let imageData: UIImage?
    let nickName: String
    let keywords: [Int]
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("다음 주제로 대화해보세요!".partialColor(["다음 주제로"], .PrimaryColor))
                    .font(.custom("온글잎 의연체", size: 34))
                VStack(spacing: 15) {
                    ProfilePicture(imageData: imageData ?? .add)
                            .frame(width: 120, height: 120)
                    Text(nickName)
                        .foregroundColor(.PrimaryColor)
                        .font(.custom("온글잎 의연체", size: 22))
                }
                
                Text("우리들의 공통점")
                    .font(.custom("온글잎 의연체", size: 22))
                
                Keywords(keywords: self.keywords)
            }
            LottieView(jsonName: "Fireworks")
                .frame(height: 400)
        }
        .padding()
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        Match(imageData: nil, nickName: "빅썬", keywords: [1,2,3])
            .preferredColorScheme(.dark)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.ThirdColor)
            )
            .previewLayout(.sizeThatFits)
    }
}
