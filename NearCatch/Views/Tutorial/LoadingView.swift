//
//  LoadingView.swift
//  NearCatch
//
//  Created by Tempnixk on 2022/06/16.
//

import SwiftUI

struct LoadingView: View {
    let coreDM: CoreDataManager
    @State private var nickname: String = ""
    @State private var profiles: [Profile] = [Profile]()
    @State private var needsRefresh: Bool = false
    
    private func populateProfiles() {
        profiles = coreDM.readAllProfile()
    }
    
    var body: some View {
        NavigationView{
            
            List {
                
                ForEach(profiles, id: \.self) { profile in
                  
                        Text(profile.nickname ?? "")
                        
                }.onDelete(perform: { IndexSet in
                    IndexSet.forEach{ index in
                    let profile = profiles[index]
                        coreDM.deleteProfile(profile: profile)
                        populateProfiles()
                    }
                })
            }.listStyle(PlainListStyle())
                .accentColor(needsRefresh ? .white: .black)
            
            Spacer()
        }.padding()
            .navigationTitle("Nicknames")
        
            .onAppear(perform: {
                populateProfiles()
            })

    }
}

struct ReadView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(coreDM: CoreDataManager())
    }
}
