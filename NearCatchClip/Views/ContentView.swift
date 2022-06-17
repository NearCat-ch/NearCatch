//
//  ContentView.swift
//  NearCatch
//
//  Created by Wonhyuk Choi on 2022/06/07.
//

import SwiftUI

struct ContentView: View {
    static var nickname: String = ""
    static var profileImage: UIImage = .add
    static var keywords: [Int] = []
    
    @State var isContentReady : Bool = false
    @State var isUserReady : Bool = false
    
    
    var body: some View {
        
        ZStack{
            if isUserReady {
                HomeView()
            } else {
                PageControlView(isUserReady: $isUserReady)
            }
            
            
            if !isContentReady {
                
                Color.white.ignoresSafeArea(.all)
                
                LottieView(jsonName: "Splash")
                    .frame(width: 120)
                    .transition(.opacity)
                    .offset(y: -20)
                
            }
            
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                withAnimation{isContentReady.toggle()}
            })
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
