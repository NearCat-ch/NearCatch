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
                Image("img_background")
                    .resizable()
                    .ignoresSafeArea()
                LottieView(jsonName: "Background")
                    .ignoresSafeArea(.all)
                VStack{
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
