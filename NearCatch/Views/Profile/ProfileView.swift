//
//  ProfileView.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/09.
//

import SwiftUI

struct ProfileView: View {
    @State var nickname: String?
    @State var profileImage: UIImage?
    @State var keywords: [Int]?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingSheet = false
    @State private var needsRefresh: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Image("img_background")
                    .resizable()
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                        .frame(height:70)
                    VStack{
                        ZStack{
                            if self.profileImage == nil {
                                SharedCustomButton(icon:"icn_img", circleSize:190, color:Color.white, innerOpacity:1)
                            }
                            else {
                                ZStack{
                                    Circle()
                                        .fill(.white.opacity(0.3))
                                    Image(uiImage: self.profileImage!)
                                        .resizable()
                                        .clipShape(Circle())
                                        .scaledToFill()
                                        .frame(width: 190, height: 190)
                                }.frame(width: 215, height: 215)
                                    .padding(.top, 25)
                            }
                        }
                        Text(nickname ?? "")
                            .font(.custom("온글잎 의연체", size: 42))
                            .foregroundColor(.white)
                    }
                    HStack{
                        VStack{
                            NavigationLink(destination: EditProfileView(nickname: Binding(get: {nickname ?? ""}, set: {nickname = $0}), profileImage: $profileImage), label: {SharedCustomButton(icon: "icn_edit", circleSize:50, color:Color.white, innerOpacity:0.5)})
                            Text("프로필 수정")
                                .font(.custom("온글잎 의연체", size: 22))
                                .foregroundColor(.white)
                        }
                        VStack{
                            Button {
                                self.showingSheet.toggle()
                            } label:{
                                SharedCustomButton(icon: "img_star_33px", circleSize:50, color:Color.PrimaryColor, innerOpacity:1)
                            }
                            .sheet(isPresented: $showingSheet) {
                                KeywordChangeView(keywords: Binding(get: {keywords ?? []}, set: {keywords = $0}))
                            }
                            Text("관심사 수정")
                                .font(.custom("온글잎 의연체", size: 22))
                                .foregroundColor(.PrimaryColor)
                        }.padding(EdgeInsets(top: 0, leading: 35, bottom: -60, trailing: 35))
                        VStack{
                            NavigationLink(destination: SetView(), label: {SharedCustomButton(icon: "icn_sat", circleSize:50, color:Color.white, innerOpacity:0.5)})
                            Text("설정")
                                .font(.custom("온글잎 의연체", size: 22))
                                .foregroundColor(.white)
                        }
                    }.padding([.top], -20)
                    ProfileInterestCard()
                        .padding(EdgeInsets(top:20, leading:0, bottom:0, trailing:0))
                    Spacer()
                }
            }
            .accentColor(needsRefresh ? .white: .black)
            .toolbar{
                ToolbarItemGroup(placement:.navigationBarLeading) {
                    Button {
                    action: do { self.presentationMode.wrappedValue.dismiss() }
                    } label:{
                        SharedCustomButton(icon: "icn_chevron", circleSize:35, color:Color.white, innerOpacity:0.5)
                    }
                }
            }
        }
        .onAppear {
            nickname = CoreDataManager.coreDM.readAllProfile()[0].nickname
            profileImage = CoreDataManager.coreDM.readAllPicture()[0].content
            keywords = CoreDataManager.coreDM.readKeyword()[0].favorite
        }
        .navigationBarHidden(true)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(nickname: "니어캣")
    }
}
