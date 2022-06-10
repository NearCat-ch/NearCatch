//
//  ProfileView.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/09.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack{
            Image("img_background")
            SharedCustomButton(icon: "icn_edit", circleSize:50, color:Color.white)
        }
        .edgesIgnoringSafeArea([.top])
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
