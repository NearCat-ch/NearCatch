//
//  SetView.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/13.
//

import SwiftUI

struct SetView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView{
            ZStack{
                Image("img_background")
                    .resizable()
                    .ignoresSafeArea()
                LottieView(jsonName: "Background")
                    .ignoresSafeArea(.all)
                VStack{
                    SharedRectangularButton(rectWidth:350, rectColor:.white, text:"앱 정보", textColor:.black)
                    NavigationLink(destination:LicenseView(), label: {
                        SettingButton(text:"라이센스")
                    })
                    
                    Spacer()
                }.padding([.top], -20)
            }
            .toolbar{
                ToolbarItemGroup(placement:.navigationBarLeading) {
                    Button {
                    action: do { self.presentationMode.wrappedValue.dismiss() }
                    } label:{
                        SharedCustomButton(icon: "icn_chevron", circleSize:35, color:Color.white, innerOpacity:0.5)
                    }
                }
            }
        }.navigationBarHidden(true)
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView()
    }
}
