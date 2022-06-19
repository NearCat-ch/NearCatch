//
//  EditProfileView.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/13.
//

import SwiftUI
import PhotosUI
struct EditProfileView: View {
    @Binding var nickname:String
    @Binding var profileImage: UIImage?
    @State var tempNick:String = ""
    @State var tempImage: UIImage?
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
                    Spacer()
                    ZStack{
                        ImageSelectButton(image: $tempImage) {
                            if self.profileImage == nil {
                                SharedCustomButton(icon:"icn_img", circleSize:190, color:Color.white, innerOpacity:1)
                            }
                            else {
                                ZStack{
                                    Circle()
                                        .fill(.white.opacity(0.3))
                                    Image(uiImage: self.tempImage ?? UIImage())
                                        .resizable()
                                        .clipShape(Circle())
                                        .scaledToFill()
                                        .frame(width: 200, height: 200)
                                        .onAppear{
                                            self.tempImage = self.profileImage
                                        }
                                        
                                        
                                }.frame(width: 190, height: 190)
                                    .padding(.top, 25)
                            }
                        }
                    }
                    Spacer()
                        .frame(height:50)
                    VStack {
                        ZStack {
                            TextField("", text: $tempNick)
                                .placeholder(when:tempNick.isEmpty){
                                    Text("User Name")
                                        .font(.custom("온글잎 의연체", size:34))
                                        .foregroundColor(Color.white)
                                        .opacity(0.3)
                                }
                                .limitText($tempNick, to: 10)
                                .font(.custom("온글잎 의연체", size:34))
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                                .frame(width:200)
                                .disableAutocorrection(true)
                                .textInputAutocapitalization(.never)
                                .onAppear{
                                    self.tempNick = self.nickname
                                }
                            HStack{
                                Spacer()
                                    .frame(width:225)
                                if tempNick != "" {
                                    Button {
                                        tempNick = ""
                                    } label: {
                                        Image("icn_cancle")
                                            .resizable()
                                            .frame(width:25, height:25)
                                    }
                                }
                            }
                        }
                        Rectangle()
                            .frame(width:260, height: 1)
                            .foregroundColor(.white)
                        Text("\(tempNick.count) / 10")
                            .font(.custom("온글잎 의연체", size:30))
                            .foregroundColor((tempNick.isEmpty || tempNick.count > 10) ? Color.red : Color.white)
                        
                    }
                    Spacer()
                        .frame(height:180)
                    Button{
                        action: do {
                            self.nickname = self.tempNick
                            self.profileImage = self.tempImage
                            CoreDataManager.coreDM.readAllProfile()[0].nickname = nickname
                            CoreDataManager.coreDM.updateProfile()
                            CoreDataManager.coreDM.readAllPicture()[0].content = profileImage
                            CoreDataManager.coreDM.updateProfile()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } label:{
                        SharedRectangularButton(rectWidth:350, rectColor:((tempNick.isEmpty || tempNick.count > 10) ? Color.ThirdColor : Color.PrimaryColor), text:"수정하기", textColor:((tempNick.isEmpty || tempNick.count > 10) ? Color.white : Color.black))
                    }.disabled(tempNick.isEmpty || tempNick.count > 10)
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
        }
        .navigationBarHidden(true)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(nickname: .constant("니어캣"), profileImage: .constant(nil))
    }
}
