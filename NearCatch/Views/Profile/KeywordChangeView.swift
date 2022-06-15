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
            }
        }
    }
}

struct KeywordChangeView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordChangeView()
    }
}
