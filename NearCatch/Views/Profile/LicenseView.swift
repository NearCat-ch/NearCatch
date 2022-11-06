//
//  LicenseView.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/14.
//

import SwiftUI

struct LicenseView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView {
            ZStack {
                //배경 이미지
                Image("img_background")
                    .resizable()
                    .ignoresSafeArea()
                
                //배경 별 LottieView
                LottieView(jsonName: "Background")
                    .ignoresSafeArea(.all)
                
                VStack{
                    //Lottie 라이센스 링크
                    ZStack{
                        Link(
                            destination: URL(string: "https://github.com/airbnb/lottie-ios")!){
                                ZStack{
                                    RoundedRectangle(cornerRadius:10)
                                        .fill(Color.white)
                                        .frame(width:350, height:60)
                                        .opacity(0.5)
                                    Text("Lottie")
                                }
                            }.font(.custom("온글잎 의연체", size:48)).foregroundColor(.black)
                    }
                    
                    //simd 라이센스 링크
                    ZStack{
                        Link(
                            destination: URL(string: "https://github.com/ermig1979/Simd")!){
                                ZStack{
                                    
                                    RoundedRectangle(cornerRadius:10)
                                        .fill(Color.white)
                                        .frame(width:350, height:60)
                                        .opacity(0.5)
                                    Text("simd")
                                }
                            }.font(.custom("온글잎 의연체", size:48)).foregroundColor(.black)
                    }
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

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        LicenseView()
    }
}
