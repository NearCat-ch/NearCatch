//
//  SetView.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/13.
//

import SwiftUI

struct SetView: View {
    var body: some View {
        NavigationView{
            ZStack{
                Image("img_background")
                    .edgesIgnoringSafeArea([.top])
                VStack{
                    HStack{
                        Spacer()
                            .frame(width:23)
                        NavigationLink(destination: ProfileView(), label: {SharedCustomButton(icon: "icn_chevron", circleSize:40, color:Color.white, innerOpacity:0.5)})
                        Spacer()
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
