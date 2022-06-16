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
                    .edgesIgnoringSafeArea([.top])
                VStack{
                    Spacer()
                        .frame(height:70)
                    ZStack{
                        RoundedRectangle(cornerRadius:10)
                            .fill(Color.white)
                            .frame(width:350, height:600)
                    }
                    Spacer()
                    
                }
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
