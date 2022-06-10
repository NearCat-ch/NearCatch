//
//  SettingNicknameView.swift
//  NearCatch
//
//  Created by ryu hyunsun on 2022/06/09.
//

import SwiftUI

struct SettingNicknameView: View {
    
    @State var nickname: String = ""
    
    var body: some View {
        VStack{
            TextField("닉네임", text: $nickname)
            Text("\(nickname)")
        }
    }
}

struct SettingNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        SettingNicknameView()
    }
}
