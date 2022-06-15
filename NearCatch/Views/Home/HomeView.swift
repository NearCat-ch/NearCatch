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
            ZStack() {
                Image("img_background")
                    .resizable()
                    .ignoresSafeArea()
                
                LottieView(jsonName: "Background")
                
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
                        
                        VStack(spacing: 24) {
                          
                            //MARK: 서로 다른 관심사 환경 위한 TEST
                            TextField("123", text: $niObject.text)
                                .padding()
                                .background(Color.green)
                                .padding()
                                .keyboardType(.numberPad)
                            
                            switch niObject.gameState {
                            case .ready:
                                HomeMainButton(state: $niObject.gameState) {
                                    niObject.start()
                                    niObject.gameState = .finding
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
                                HomeMainButton(state: $niObject.gameState) {
                                    niObject.stop()
                                    niObject.gameState = .ready
                                }
                                StarBubble(count: niObject.peersCnt)
                            case .found:
                                HomeMainButton(state: $niObject.gameState) {
                                    niObject.stop()
                                    niObject.gameState = .ready
                                }
                                HeartBubble()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        }
        .navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
