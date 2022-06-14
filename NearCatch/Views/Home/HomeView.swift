//
//  HomeView.swift
//  NearCatch
//
//  Created by Wonhyuk Choi on 2022/06/09.
//

import SwiftUI

struct HomeView: View {
    let localNetAuth = LocalNetworkAuthorization()
    @StateObject var niObject = NISessionManager()
    @State var gameState : GameState = .ready
    @State var isLocalNetworkPermissionDenied = false
    @Environment(\.scenePhase) var scenePhase
    
    @State var isLaunched = true
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView{
            ZStack() {
                Image("img_basicbackground")
                    .resizable()
                    .ignoresSafeArea()
                
                LottieView(jsonName: "Background")
                
                if isLocalNetworkPermissionDenied || niObject.isPermissionDenied {
                    PermissionCheckView()
                } else {
                    ZStack {
                        VStack {
                            Spacer()
                            if gameState == .finding {
                                Tip {
                                    VStack {
                                        Text("Tip 니어캣과 함께 주변을 돌아다녀 보세요".partialColor(["Tip", "니어캣"], .PrimaryColor))
                                        Text("니어캣이 진동으로 인연의 별을 알려드릴 거에요".partialColor(["니어캣"], .PrimaryColor))
                                    }
                                    .font(.custom("온글잎 의연체", size: 28))
                                    .frame(maxWidth: .infinity)
                                }
                                .padding()
                            }
                        }
                        
                        VStack(spacing: 24) {
                            switch gameState {
                            case .ready:
                                HomeMainButton(state: $gameState) {
                                    niObject.start()
                                    gameState = .finding
                                    if isLaunched {
                                        localNetAuth.requestAuthorization { auth in
                                            isLocalNetworkPermissionDenied = !auth
                                        }
                                        isLaunched = false
                                    }
                                }
                                Text("니어캣을 눌러서\n새로운 인연을 찾아보세요!")
                                    .font(.custom("온글잎 의연체", size: 28))
                                    .multilineTextAlignment(.center)
                            case .finding:
                                HomeMainButton(state: $gameState) {
                                    niObject.stop()
                                    gameState = .ready
                                }
                                StarBubble(count: niObject.peersCnt)
                            case .found:
                                HomeMainButton(state: $gameState) {
                                    niObject.stop()
                                    gameState = .ready
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .onChange(of: scenePhase) { newValue in
                if !isLaunched {
                    localNetAuth.requestAuthorization { auth in
                        isLocalNetworkPermissionDenied = !auth
                    }
                }
            }
            .toolbar{
                ToolbarItemGroup(placement:.navigationBarTrailing) {
                    NavigationLink(destination: ProfileView(), label: {Image("icn_person").resizable()
                            .frame(width:35*1.2, height:35*1.2)
                    })
                }
            }
        }.navigationBarHidden(true)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
