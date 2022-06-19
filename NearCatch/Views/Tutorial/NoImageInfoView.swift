//
//  NoImageInfoView.swift
//  NearCatch
//
//  Created by ryu hyunsun on 2022/06/15.
//

import SwiftUI

struct NoImageInfoView: View {
    // 메인스레드에서 돌리기.
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State private var currentIndex = 0
    var body: some View {
        VStack{
            Text("선택된 이미지가 없습니다!")
                .font(.custom("온글잎 의연체", size: 20))
            Text("Setting에서 설정을 변경해주세요")
                .font(.custom("온글잎 의연체", size: 30))
            
            TabView (selection: $currentIndex){
                ForEach(0..<2) { num in
                    if num == 0 {
                        Image("img_permissionthirdstep")
                            .resizable()
                            .scaledToFit()
                            .tag(num)
                    }
                    else {
                        Image("img_permissionfirststep")
                            .resizable()
                            .scaledToFit()
                            .tag(num)
                    }
    //                Image("no_image_info\(num)")
    //                    .resizable()
    //                    .scaledToFit()
    //                    .tag(num)
                        
                }
                
    //
    //            Image("image_permission_info2")
    //                .resizable()
    //                .scaledToFit()
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .onReceive(timer, perform: { _ in
                    withAnimation {
                        currentIndex = currentIndex < 1 ? currentIndex + 1 : 0
                    }
                })
                .frame(height: UIScreen.main.bounds.height * 2 / 4)
    //            .disabled(true)
            
            Button {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.PrimaryColor)
                        .frame(maxWidth: .infinity).frame(height: 50)
                    
                    Text("설정 바로가기")
                        .foregroundColor(.black)
                        .font(.custom("온글잎 의연체", size: 28))
                }
            }
            .padding(.top,30)
            .padding(.leading,20)
            .padding(.trailing,20)
        }
        

    }
}

struct NoImageInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NoImageInfoView()
    }
}
