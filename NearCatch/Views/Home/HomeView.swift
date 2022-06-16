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
    @State var isLocalNetworkPermissionDenied = false
    @Environment(\.scenePhase) var scenePhase
    
    @State var isLaunched = true
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView{
            ZStack {
                Image("img_background")
                    .resizable()
                    .ignoresSafeArea()
                
                LottieView(jsonName: "Background")
                    .ignoresSafeArea(.all)
                
                if isLocalNetworkPermissionDenied || niObject.isPermissionDenied {
                    PermissionCheckView()
                } else {
                    ZStack {
                        VStack {
                            Spacer()
                            if niObject.gameState == .finding {
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
                        
                        VStack {
                            Spacer()
                                .frame(height: 120 + 54)
                            
                            switch niObject.gameState {
                            case .ready:
                                Text("니어캣을 눌러서\n새로운 인연을 찾아보세요!")
                                    .font(.custom("온글잎 의연체", size: 28))
                                    .multilineTextAlignment(.center)
                            case .finding:
                                StarBubble(count: niObject.peersCnt)
                            case .found:
                                HeartBubble()
                            }
                        }
                    }
                }
                
                HomeMainButton(state: $niObject.gameState) {
                    withAnimation {
                        switch niObject.gameState {
                        case .ready:
                            niObject.start()
                            niObject.gameState = .finding
                            if isLaunched {
                                localNetAuth.requestAuthorization { auth in
                                    isLocalNetworkPermissionDenied = !auth
                                }
                                isLaunched = false
                            }
                        case .finding:
                            niObject.stop()
                            niObject.gameState = .ready
                        case .found:
                            niObject.stop()
                            niObject.gameState = .ready
                        }
                    }
                }
            }
            .toolbar{
                ToolbarItemGroup(placement:.navigationBarTrailing) {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Image("icn_person")
                            .resizable()
                            .frame(width:35*1.2, height:35*1.2)
                    }
                    .offset(
                        x : niObject.gameState == .ready ? 0 : 100,
                        y : niObject.gameState == .ready ? 0 : -100
                    )
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
        .customSheet(isPresented: $niObject.isBumped) {
            VStack(spacing: 20) {
                Text("\(niObject.matchedName)님과 대화해보세요!"
                    .partialColor(["\(niObject.matchedName)"],
                                  .PrimaryColor))
                
                Spacer()
                
                ProfilePicture(imageData: Data())
                    .frame(width: 120, height: 120)
                
                Spacer()
                
                Text("우리들의 공통점")
                    .font(.callout)
            }
            .frame(width: 300, height: 300)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
