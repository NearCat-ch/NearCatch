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
                // 임시. 이미지 데이터 못받으면 무슨 사진 불러올 지?
                Image(systemName: "photo")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicture(imageData: Data())
            .frame(width: 120, height: 120)
            .preferredColorScheme(.dark)
            .padding(20)
            .previewLayout(.sizeThatFits)
    }
}
