//
//  LoadingView.swift
//  NearCatch
//
//  Created by Tempnixk on 2022/06/16.
//

import SwiftUI
import UIKit

struct LoadingView: View {
    let coreDM: CoreDataManager
    @State private var nickname: String = ""
    @State private var profiles: [Profile] = [Profile]()
    @State private var needsRefresh: Bool = false
    
    @State private var content: [Picture] = []
//    @State private var profileImage
    
    @State private var favorites: [Keyword] = []
    private func populateProfiles() {
        profiles = coreDM.readAllProfile()
        content = coreDM.readAllPicture()
        favorites = coreDM.readKeyword()
    }
    
    var body: some View {
        VStack{
            if profiles.count != 0 {
                Text(profiles[0].nickname!)
            }
            if content.count != 0{
                Image(uiImage: content[0].content!)
                    .resizable()
            }
            if favorites.count != 0{
                ForEach(0..<favorites[0].favorite.count, id:\.self) {i in
                    Text("\(favorites[0].favorite[i])")
                }
            }
            
            
//
//            List {
//
//                ForEach(profiles, id: \.self) { profile in
//
//                        Text(profile.nickname ?? "")
//
//                }.onDelete(perform: { IndexSet in
//                    IndexSet.forEach{ index in
//                    let profile = profiles[index]
//                        coreDM.deleteProfile(profile: profile)
//                        populateProfiles()
//                    }
//                })
//            }.listStyle(PlainListStyle())
//                .accentColor(needsRefresh ? .white: .black)
//            Spacer()
        }
        .onAppear{
            populateProfiles()
            
            print(profiles.count)
            print(profiles[0].nickname)
            
            
            print(content.count)
            print(content[0])
        }
            
            
    }
        
}
//
//struct ReadView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoadingView(coreDM: CoreDataManager())
//    }
//}
