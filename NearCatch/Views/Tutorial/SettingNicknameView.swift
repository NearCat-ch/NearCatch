//
//  SettingNicknameView.swift
//  NearCatch
//
//  Created by ryu hyunsun on 2022/06/09.
//

import SwiftUI

struct SettingNicknameView: View {
    
    let coreDM: CoreDataManager
    @State private var lotOfMydata: [Profile] = [Profile]()
    private func populateMydatum() {
        lotOfMydata = coreDM.readAllProfile()
    }
    
    @Binding var nickname: String
    
    var body: some View {
        VStack{
            Text("당신의 이름을 니어캣에게 알려주세요!")
                .foregroundColor(Color(red: 255/255, green: 236/255, blue: 108/255))
                .font(.custom("온글잎 의연체", size: 34))
                .padding(.top, 45)
                .padding(.bottom, 10)
            Text("니어캣에게 이름을 알려주세요")
                .foregroundColor(.white)
                .font(.custom("온글잎 의연체", size: 24))
            Text("나중에 프로필 변경에서 변경할 수 있습니다.")
                .foregroundColor(.white)
                .font(.custom("온글잎 의연체", size: 24))
            Image("img_standing")
                .padding(.bottom, 20.0)
                .padding(.top, 15)
            
            ZStack {
                
                TextField("",text: $nickname)
                    .placeholder(when: nickname.isEmpty) {
                        Text("User Name").foregroundColor(.white)
                    }
                    .limitText($nickname, to: 10)
                    .foregroundColor(.white)
                    .font(.custom("온글잎 의연체", size: 34))
                    .frame(width: 200,height: 34)
                    .multilineTextAlignment(.center)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
    //            Text("\(nickname)")
                HStack{
                    Spacer()
                    Image("icn_cancle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            self.nickname = ""
                        }
                }
                .frame(width: 250)
                
                
            }
            Divider()
                .frame(width: 250, height: 1)
                .background(Color.white)

            
        }
    }
}

// Mark: 텍스트필드 placeholder 색상 변경, 텍스트필드 글자수 제한을 위한 View 확장
extension View {
    // placeholder 설정 함수.
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .center,
        @ViewBuilder placeholder: () -> Content) -> some View {
        //shouldShow가 true면 보여주고, false면 안보여주기.
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    // 텍스트 필드 글자수 제한.
    func limitText(_ text: Binding<String>, to characterLimit: Int) -> some View {
            self
                .onChange(of: text.wrappedValue) { _ in
                    text.wrappedValue = String(text.wrappedValue.prefix(characterLimit))
                }
        }
    
}


struct SettingNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        SettingNicknameView(coreDM: CoreDataManager(), nickname: .constant(""))
    }
}
