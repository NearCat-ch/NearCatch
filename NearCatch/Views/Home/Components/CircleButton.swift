//
//  CircleButton.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/09.
//

import SwiftUI

struct CircleButton: View {
    
    var imageName: String
    var action: () -> Void
    
    init(imageName: String, action: @escaping () -> Void) {
        self.imageName = imageName
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(imageName)
                .resizable()
                .scaledToFit()
        }

    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CircleButton(imageName: "icn_person") {
                print("hi")
            }
            .frame(width: 40, height: 40)
            
            CircleButton(imageName: "icn_cancle") {
                print("hi")
            }
            .frame(width: 40, height: 40)
        }
        .padding(20)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
