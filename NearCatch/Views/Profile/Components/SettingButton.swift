//
//  SettingButton.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/14.
//

import SwiftUI

struct SettingButton: View {
    var text:String
    var body: some View {
        ZStack{
            HStack{
                Text(text)
                    .font(.custom("온글잎 의연체", size:22))
                    .foregroundColor(.white)
                Spacer()
                    .frame(width:250)
                Image(systemName:"chevron.right")
                    .foregroundColor(.white)
                    .font(.custom("온글잎 의연체", size:16))
                
            }.overlay(Rectangle()
                .fill(Color.white)
                .opacity(0.3)
                .frame(width:350, height:50))
        }.padding([.bottom], 20)
        
    }
}

struct SettingButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingButton(text:"라이센스")
    }
}
