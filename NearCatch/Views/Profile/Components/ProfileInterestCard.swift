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
                .frame(width:350, height:200)
            VStack {
                Text("내 관심사")
                    .font(.custom("온글잎 의연체", size:28))
                    .foregroundColor(Color.white)
                    .padding([.trailing], 210)
                Keywords(keywords: keywords)
            }
        }
    }
}

struct ProfileInterestCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInterestCard(keywords: [1, 2, 3, 4, 5, 6, 7, 8])
    }
}
