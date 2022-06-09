//
//  StarBubbleView.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/09.
//

import SwiftUI

struct StarBubbleView: View {
    var count: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.5))
                .frame(width: 86, height: 86)
            
            Circle()
                .fill(.white.opacity(0.5))
                .frame(width: 86, height: 86)
                .padding(10)
            
            Image("img_star_58px")
                .resizable()
                .scaledToFit()
                .frame(width: 58, height: 58)
            
            Image("img_bubble_86px")
        }
    }
}

struct StarBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        StarBubbleView(count: 2)
            .preferredColorScheme(.dark)
            .padding(20)
            .previewLayout(.sizeThatFits)
    }
}
