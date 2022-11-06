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
                //배경 이미지
                Image("img_background")
                    .resizable()
                    .ignoresSafeArea()
                
                //배경 별 LottieView
                LottieView(jsonName: "Background")
                    .ignoresSafeArea(.all)
                
                VStack{
                    //앱 정보 제목 칸
                    ZStack{
                        Rectangle()
                            .fill(.white)
                            .opacity(0.3)
                            .frame(width:350, height:20)
                            .padding([.top], 30)
                        SharedRectangularButton(rectWidth:350, rectColor:.white, text:"앱 정보", textColor:.black)
                    }
                    
                    //LicenseView 이동 버튼
                    NavigationLink(destination:LicenseView(), label: {
                        SettingButton(text:"라이센스", isEnd:true)
                    }).padding([.top], -8)
                    
                    Spacer()
                }.padding([.top], -20)
            }
            //뒤로가기 버튼
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
