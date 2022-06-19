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
            HStack {
                Text("내 관심사")
                    .font(.custom("온글잎 의연체", size:28))
                    .foregroundColor(Color.white)
                Spacer()
            }
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
