//
//  ProfileInterestCard.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/12.
//

import SwiftUI

struct ProfileInterestCard: View {
    let keywords : [Int]
    
    var body: some View {
        VStack {
            //내 관심사 제목
            HStack {
                Text("내 관심사")
                    .font(.custom("온글잎 의연체", size:28))
                    .foregroundColor(Color.white)
                Spacer()
            }
            //자신의 관심사 키워드 나열
            KeywordScroll(keywords: keywords)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.ThirdColor)
        )
    }
}

struct ProfileInterestCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInterestCard(keywords: [1, 2, 3, 10, 20, 30, 40, 50, 60])
            .previewLayout(.sizeThatFits)
    }
}
