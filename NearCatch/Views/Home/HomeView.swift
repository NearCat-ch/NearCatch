//
//  HomeView.swift
//  NearCatch
//
//  Created by Wonhyuk Choi on 2022/06/09.
//

import SwiftUI

struct HomeView: View {
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
                    
                } label: {
                    Circle()
                        .frame(width: 220, height: 220)
                }
                Text("Hello")
                    .font(.system(size: 28))
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
