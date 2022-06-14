//
//  EditProfileView.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/13.
//

import SwiftUI

struct EditProfileView: View {
    @State var nickname:String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
            ZStack{
                Image("img_background")
                    .edgesIgnoringSafeArea([.top])
                VStack{
                    Spacer()
                    ZStack{
                        SharedCustomButton(icon:"icn_img", circleSize:191, color:Color.white, innerOpacity:1)
                    }
                    Spacer()
                        .frame(height:50)
                    VStack {
                        ZStack {
                            TextField("니어캣", text: $nickname)
                                .font(.custom("온글잎 의연체", size:34))
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                                .frame(width:200)
                                .textInputAutocapitalization(.never)
                            HStack{
                                Spacer()
                                    .frame(width:225)
                                if nickname != "" {
                                    Button {
                                        nickname = ""
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
                        Text("\(nickname.count) / 10")
                            .font(.custom("온글잎 의연체", size:30))
                            .foregroundColor((nickname.isEmpty || nickname.count > 10) ? Color.red : Color.white)
                        
                    }
                    Spacer()
                        .frame(height:180)
                    Button{
                        action: do { self.presentationMode.wrappedValue.dismiss() }
                    } label:{
                        SharedRectangularButton(rectWidth:350, rectColor:((nickname.isEmpty || nickname.count > 10) ? Color.gray : Color.PrimaryColor), text:"수정하기", textColor:((nickname.isEmpty || nickname.count > 10) ? Color.white : Color.black))
                    }.disabled(nickname.isEmpty || nickname.count > 10)
                    
                    Spacer()
                }
            }
            .toolbar{
                ToolbarItemGroup(placement:.navigationBarLeading) {
                    Button {
                    action: do { self.presentationMode.wrappedValue.dismiss() }
                    } label:{
                        SharedCustomButton(icon: "icn_chevron", circleSize:40, color:Color.white, innerOpacity:0.5)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(nickname:"마이즈")
    }
}
