//
//  HomeView.swift
//  NearCatch
//
//  Created by Wonhyuk Choi on 2022/06/09.
//

import SwiftUI

struct HomeView: View {
    @State var toggle: Bool = false
    @StateObject var nearbyInterationObject = NearbyInteractionManager()
//    var delegate: NearbyInteractionManagerDelegate?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button {
            
            } label: {
                Circle()
                    .frame(width: 40, height: 40)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 24) {
                Button {
                    if toggle {
                        nearbyInterationObject.shutdown()
                    } else {
                        nearbyInterationObject.startup()
                    }
                    toggle = !toggle
                } label: {
                    Circle()
                        .frame(width: 220, height: 220)
                }
                Text(
                    toggle ?
                    "켜짐"
                    : "니어캣을 눌러서\n새로운 인연을 찾아보세요!")
                    .font(.system(size: 28))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
