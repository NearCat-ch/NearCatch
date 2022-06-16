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
            Image("img_hurray")
                .padding(EdgeInsets(top:0, leading:0, bottom:250, trailing:240))
            RoundedRectangle(cornerRadius:30)
                .fill(Color.ThirdColor)
                .frame(width:350, height:250)
            VStack {
                Text("내 관심사")
                    .font(.custom("온글잎 의연체", size:34))
                    .foregroundColor(Color.white)
                Keywords(keywords: keywords)
            }
            .padding(EdgeInsets(top:0, leading:50, bottom:0, trailing:50))
        }
    }
}

struct ProfileInterestCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInterestCard(keywords: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    }
}
