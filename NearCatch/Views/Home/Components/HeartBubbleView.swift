//
//  HeartBubbleView.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/09.
//

import SwiftUI

struct HeartBubbleView: View {
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.5))
            
            Circle()
                .fill(.white.opacity(0.5))
                .padding(5)
            
            Image("img_star_58px")
            
            Image("img_bubble_86px")
        }
    }
}

struct HeartBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        HeartBubbleView()
            .preferredColorScheme(.dark)
    }
}
