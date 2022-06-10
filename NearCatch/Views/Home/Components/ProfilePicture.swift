//
//  CircleProfilePicture.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/10.
//

import SwiftUI

struct ProfilePicture: View {
    
    // 미확정
    var imageData: Data
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
            
            Circle()
                .stroke(.white.opacity(0.5), lineWidth: 16)
            
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .padding(5)
            } else {
                Image("img_sunglass_190px")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .padding(5)
            }
        }
    }
}

struct ProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicture(imageData: Data())
            .frame(width: 120, height: 120)
            .preferredColorScheme(.dark)
            .padding(50)
            .previewLayout(.sizeThatFits)
    }
}
