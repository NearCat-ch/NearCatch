//
//  ContentView.swift
//  NearCatch
//
//  Created by Wonhyuk Choi on 2022/06/07.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var nickname: [Profile] = [Profile]()
    @State private var profileImage: [Picture] = []
    @State private var keywords: [Keyword] = []
    
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
            populateProfiles()
            if nickname.count == 0 || profileImage.count == 0 || keywords.count == 0 {
                isUserReady = false
            }
            else {
                isUserReady = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {withAnimation{isContentReady.toggle()}
            })
        }
    }
    
    
    private func populateProfiles() {
        nickname = CoreDataManager.coreDM.readAllProfile()
        profileImage = CoreDataManager.coreDM.readAllPicture()
        keywords = CoreDataManager.coreDM.readKeyword()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
