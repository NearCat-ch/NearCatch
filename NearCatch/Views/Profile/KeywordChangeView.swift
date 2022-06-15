//
//  KeywordChangeView.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/14.
//

import SwiftUI

struct KeywordChangeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            Image("img_background")
                .edgesIgnoringSafeArea([.top])
            VStack{
                Spacer()
                    .frame(height:60)
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                }) {
                    RoundedRectangle(cornerRadius:10)
                        .foregroundColor(.white)
                        .frame(width:50, height:5)
                }
                Spacer()
                    .frame(height:70)
                HStack {
                    Text("관심사")
                        .font(.custom("온글잎 의연체", size:34))
                        .foregroundColor(.PrimaryColor)
                    Text("수정")
                        .font(.custom("온글잎 의연체", size:34))
                        .foregroundColor(.white)
                }
                Text("최소 5개 이상 선택하셔야합니다!")
                    .font(.custom("온글잎 의연체", size:22))
                    .foregroundColor(.white)
                Text("5 / 10")
                    .font(.custom("온글잎 의연체", size:34))
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
}

struct KeywordChangeView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordChangeView()
    }
}
