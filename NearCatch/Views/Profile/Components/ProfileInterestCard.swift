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
        ZStack{
            RoundedRectangle(cornerRadius:30)
                .fill(Color.ThirdColor)
                .frame(width: UIScreen.main.bounds.width * 0.85, height:190)
            VStack {
                Text("내 관심사")
                    .font(.custom("온글잎 의연체", size:28))
                    .foregroundColor(Color.white)
                KeywordScroll(keywords: keywords)
            }
        }
    }
}

struct ProfileInterestCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInterestCard(keywords: [1, 2, 3, 10, 20, 30, 40, 50, 60])
    }
}
