//
//  ProfileView.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/09.
//

import SwiftUI

struct ProfileView: View {
    @State private var nickname = "나"
    var body: some View {
        NavigationView{
            ZStack{
                Image("img_background")
                VStack{
                    HStack{
                        NavigationLink(destination: HomeView(), label: {SharedCustomButton(icon: "icn_chevron", circleSize:40, color:Color.white, innerOpacity:0.5)
                            .padding(EdgeInsets(top: 0, leading: 23, bottom: 0, trailing: 0))})
                        Spacer()
                    }
                    VStack{
                        ZStack{
                            SharedCustomButton(icon:"icn_img", circleSize:191, color:Color.white, innerOpacity:1)
                        }
                        Text(nickname)
                            .font(.system(size: 42))
                            .foregroundColor(.white)
                    }
                    HStack{
                        VStack{
                            NavigationLink(destination: HomeView(), label: {SharedCustomButton(icon: "icn_edit", circleSize:50, color:Color.white, innerOpacity:0.5)})
                            Text("프로필 수정")
                                .font(.system(size:22))
                                .foregroundColor(.white)
                        }
                        VStack{
                            NavigationLink(destination: HomeView(), label: {SharedCustomButton(icon: "img_star_33px", circleSize:50, color:Color.yellow, innerOpacity:1)
                            })
                            Text("관심사 수정")
                                .font(.system(size:22))
                                .foregroundColor(.yellow)
                        }.padding(EdgeInsets(top: 25, leading: 38, bottom: 0, trailing: 38))
                        VStack{
                            NavigationLink(destination: HomeView(), label: {SharedCustomButton(icon: "icn_sat", circleSize:50, color:Color.white, innerOpacity:0.5)})
                            Text("설정")
                                .font(.system(size:22))
                                .foregroundColor(.white)
                        }
                    }
                }
                    
            }
            .edgesIgnoringSafeArea([.top])
        }.navigationBarHidden(true)
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
