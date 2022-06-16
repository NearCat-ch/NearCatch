//
//  SettingKeywordView.swift
//  NearCatch
//
//  Created by Tempnixk on 2022/06/12.
//

import SwiftUI

struct SettingKeywordView: View {
    
    @Binding var nickname: String
    @Binding var profileImage: UIImage?
    
    @StateObject var tagData = TagViewModel()
    @ObservedObject var togglecount = ToggleCount()
    @State var tag:Int? = nil
    
    @Binding var isUserReady: Bool
    
    var isDisabledButton: Bool = true
    
    var body: some View {
        
        
        VStack {
            Spacer()
            Text("관심사를 선택해주세요!").font(.custom("온글잎 의연체", size: 34))
            Text("최소 5개 이상 선택해야 해요!").font(.custom("온글잎 의연체", size: 22))
            Text("\(togglecount.keywordCounter) / 10").font(.custom("온글잎 의연체", size: 34))
            Spacer()
            
            ScrollView(.horizontal) {
                VStack(alignment: .leading){
                    HStack{
                        ForEach(0..<14, id: \.self) { i in
                            //                            if self.togglecount.keywordCounter <= 10 {
                            Button(action: {
                                if tagData.Tags[i].isSelected == true {
                                    tagData.Tags[i].isSelected = false
                                    self.togglecount.keywordCounter -= 1
                                } else {
                                    tagData.Tags[i].isSelected = true
                                    self.togglecount.keywordCounter += 1
                                }
                            }){
                                ZStack{
                                    if tagData.Tags[i].isSelected == true{
                                        Text(tagData.Tags[i].name)
                                            .tagView(.black, .PrimaryColor)
                                    }
                                    else{
                                        Text(tagData.Tags[i].name)
                                            .tagView(.gray, .ThirdColor)
                                    }
                                }
                            }
                            //              }
                            //                 else {
                            //팝업 10개까지만 선택할 수 있습니다?
                            //                   }
                            
                        }
                    }
                    HStack{
                        ForEach(14..<30, id: \.self) { i in
                            Button(action: {
                                if tagData.Tags[i].isSelected == true {
                                    tagData.Tags[i].isSelected = false
                                    self.togglecount.keywordCounter -= 1
                                } else {
                                    tagData.Tags[i].isSelected = true
                                    self.togglecount.keywordCounter += 1
                                }
                            }){
                                ZStack{
                                    if tagData.Tags[i].isSelected == true{
                                        Text(tagData.Tags[i].name)
                                            .tagView(.black, .PrimaryColor)
                                    }
                                    else{
                                        Text(tagData.Tags[i].name)
                                            .tagView(.gray, .ThirdColor)
                                        
                                    }
                                }
                            }
                        }
                    }
                    HStack{
                        ForEach(30..<45, id: \.self) { i in
                            Button(action: {
                                
                                if tagData.Tags[i].isSelected == true {
                                    tagData.Tags[i].isSelected = false
                                    self.togglecount.keywordCounter -= 1
                                } else {
                                    tagData.Tags[i].isSelected = true
                                    self.togglecount.keywordCounter += 1
                                }
                            }){
                                ZStack{
                                    if tagData.Tags[i].isSelected == true{
                                        Text(tagData.Tags[i].name)
                                            .tagView(.black, .PrimaryColor)
                                    }
                                    else{
                                        Text(tagData.Tags[i].name)
                                            .tagView(.gray, .ThirdColor)
                                    }
                                }
                            }
                        }
                    }
                    HStack{
                        ForEach(45..<60, id: \.self) { i in
                            Button(action: {
                                if tagData.Tags[i].isSelected == true {
                                    tagData.Tags[i].isSelected = false
                                    self.togglecount.keywordCounter -= 1
                                } else {
                                    tagData.Tags[i].isSelected = true
                                    self.togglecount.keywordCounter += 1
                                }
                            }){
                                if tagData.Tags[i].isSelected == true{
                                    Text(tagData.Tags[i].name)
                                        .tagView(.black, .PrimaryColor)
                                }
                                else{
                                    Text(tagData.Tags[i].name)
                                        .tagView(.gray, .ThirdColor)
                                }
                            }
                            
                        }
                    }
                    HStack{
                        ForEach(60..<75, id: \.self) { i in
                            Button(action: {
                                
                                if tagData.Tags[i].isSelected == true {
                                    tagData.Tags[i].isSelected = false
                                    self.togglecount.keywordCounter -= 1
                                } else {
                                    tagData.Tags[i].isSelected = true
                                    self.togglecount.keywordCounter += 1
                                }
                            }){
                                ZStack{
                                    if tagData.Tags[i].isSelected == true{
                                        Text(tagData.Tags[i].name)
                                            .tagView(.black, .PrimaryColor)
                                    }
                                    else{
                                        Text(tagData.Tags[i].name)
                                            .tagView(.gray, .ThirdColor)
                                    }
                                }
                            }
                        }
                    }
                    HStack{
                        ForEach(75..<86, id: \.self) { i in
                            Button(action: {
                                
                                if tagData.Tags[i].isSelected == true {
                                    tagData.Tags[i].isSelected = false
                                    self.togglecount.keywordCounter -= 1
                                } else {
                                    tagData.Tags[i].isSelected = true
                                    self.togglecount.keywordCounter += 1
                                }
                            }){
                                if tagData.Tags[i].isSelected == true{
                                    Text(tagData.Tags[i].name)
                                        .tagView(.black, .PrimaryColor)
                                }
                                else{
                                    Text(tagData.Tags[i].name)
                                        .tagView(.gray, .ThirdColor)
                                }
                            }
                            
                        }
                    }
                }
            }
            Spacer()
            
            // 관심사 저장버튼
            Button("관심사 저장", action: {
                CoreDataManager.coreDM.createProfile(nickname: nickname)
                if let profileImage = profileImage {
                    let profileImage2 = ImageConverter.resize(image: profileImage)
                    CoreDataManager.coreDM.createPicture(content: profileImage2)
                } else {
                    let x = UIImage(named: "img_sunglass_68px")!
                    CoreDataManager.coreDM.createPicture(content: x)
                }
                var tempList : [Int] = []
                for i in 0 ..< 86 {
                    if tagData.Tags[i].isSelected == true {
                        tempList.append(tagData.Tags[i].index)
                    }
                }
                CoreDataManager.coreDM.createKeyword(favorite: tempList)
                //                    print(tempList)
                self.isUserReady = true
                            
            }).foregroundColor(.black)
                .padding(.horizontal, 30).padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.PrimaryColor))
                .shadow(radius: 1)
            
            Spacer()
            
        }
    }
}

extension View {
    func tagView(_ forgroundColor: Color, _ backgroundColor: Color) -> some View {
        self.modifier(TagViewModifier(forgroundColor: forgroundColor, backgroundColor: backgroundColor))
    }
}

struct TagViewModifier: ViewModifier {
    
    var forgroundColor: Color
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(forgroundColor)
            .padding(.horizontal).padding(.vertical, 10)
            .background(Capsule().fill(backgroundColor))
            .shadow(radius: 5)
    }
}

//
//struct SettingKeywordView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingKeywordView(nickname: .constant("sad"), profileImage: .constant(UIImage("")))
//    }
//}
