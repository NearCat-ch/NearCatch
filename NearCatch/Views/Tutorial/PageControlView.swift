//
//  PageControlView.swift
//  NearCatch
//
//  Created by ryu hyunsun on 2022/06/09.
//

import SwiftUI

struct PageControlView: View {
    @State var currentPage = 0
    @State private var offset: CGSize = .zero
    @State var nickname: String = ""
    @State var profileImage: UIImage?
    @Binding var isUserReady: Bool
    
    var body: some View {
        ZStack{
            Image("img_background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack{
                ZStack{
                    pageControl(current: $currentPage)
                        .frame(height: 30)
                    if currentPage == 1{
                        Button(action: {
                            self.currentPage += 1
                        }){
                            VStack{
                            }.frame(maxWidth: .infinity, idealHeight: 28)
                            Text("건너뛰기")
                                .multilineTextAlignment(.trailing)
                                .padding(.trailing)
                                .font(.custom("온글잎 의연체", size: 28))
                                .foregroundColor(Color(red: 174/255, green: 174/255, blue: 178/255))
                        }
                    }
                }
                
                
                VStack {
                    if currentPage == 0 {

                        SettingNicknameView(nickname: $nickname, currentPage:$currentPage)

                            

                    }
                    else if currentPage == 1 {
                        SettingProfileImageView(profileImage: $profileImage)

                    }
                    else {
                        SettingKeywordView(nickname: $nickname, profileImage: $profileImage, isUserReady: $isUserReady, currentPage: $currentPage)
//                        Image("img_shooting")
                    }
                }
            }
            .frame(
                maxHeight: .infinity,
                alignment: .topLeading
            )
            
            
        }.gesture(DragGesture()
            .onChanged{self.offset = $0.translation}
            .onEnded{
                if $0.translation.width < -100 {
                    if self.currentPage < 3 {
                        withAnimation{
                            self.currentPage += 1
                        }
                        
                            
                    }
                    else {
                        self.offset = .zero
                    }
                }
                else if $0.translation.width > 100 {
                    if self.currentPage > 0 {
                        withAnimation{
                            self.currentPage -= 1
                        }
                    }
                    else {
                        self.offset = .zero
                    }
                }
                else {
                    self.offset = .zero
                }
                
            }
        )
    }
}


struct pageControl : UIViewRepresentable {
//    var current = 0
    @Binding var current: Int
    
    func makeUIView(context: UIViewRepresentableContext<pageControl>) -> UIPageControl {
        let page = UIPageControl()
        page.currentPageIndicatorTintColor = UIColor(red: 255/255, green: 236/255, blue: 108/255, alpha: 100.0)
        page.numberOfPages = 3
        page.pageIndicatorTintColor = .white
//        page.isSelected = false
        return page
    }
    
    func updateUIView(_ uiView: UIPageControl, context: UIViewRepresentableContext<pageControl>) {
        uiView.currentPage = self.current
    }
    
}





struct PageControlView_Previews: PreviewProvider {
    static var previews: some View {
        PageControlView(isUserReady: .constant(false))
    }
}
