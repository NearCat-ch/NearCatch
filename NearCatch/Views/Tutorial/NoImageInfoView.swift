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
        TabView (selection: $currentIndex){
            ForEach(0..<2) { num in
                Image("no_image_info\(num)")
                    .resizable()
                    .scaledToFit()
                    .tag(num)
                    
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
//            .disabled(true)
    }
}

struct NoImageInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NoImageInfoView()
    }
}
