//
//  ImageLoadingView.swift
//  NearCatch
//
//  Created by ryu hyunsun on 2022/06/17.
//

import SwiftUI

struct ImageLoadingView: View {
    @State private var isAnimating = false
    
    var foreverAnimation: Animation {
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        VStack{
            Image("img_star_58px")
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                .animation(foreverAnimation, value: self.isAnimating)
//                .animation(self.isAnimating ? foreverAnimation : .default)
                .onAppear { self.isAnimating = true }
                .onDisappear { self.isAnimating = false }
            Text("이미지를 로드하는 중이에요!")
                .font(.custom("온글잎 의연체", size: 34))
            Text("잠시만 기다려주세요!")
                .font(.custom("온글잎 의연체", size: 34))
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background(.black.opacity(0.5))
    }
}

struct ImageLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoadingView()
    }
}
