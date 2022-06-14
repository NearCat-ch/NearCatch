//
//  ContentView.swift
//  NearCatch
//
//  Created by Wonhyuk Choi on 2022/06/07.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var isContentReady : Bool = false
    
    var body: some View {
        
        ZStack{
            
            HomeView()
            
            if !isContentReady {
                
                ZStack{
//                    Image("img_background")
//                        .ignoresSafeArea(.all)
                    
                    Color.white.ignoresSafeArea(.all)
                    
                    LottieView(jsonName: "Splash")
                        .transition(.opacity)
                        .frame(width: 150)
                }
               
            }
            
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {withAnimation{isContentReady.toggle()}
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
