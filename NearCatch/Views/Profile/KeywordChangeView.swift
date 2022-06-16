//
//  KeywordChangeView.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/14.
//

import SwiftUI

struct KeywordChangeView: View {
    @StateObject var tagData = TagViewModel()
    @State var tag:Int? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var keywords : [Int]
    @State var duplicatedkeywords : [Int] = []
    
    var body: some View {
        ZStack {
            Image("img_background")
                .resizable()
                .ignoresSafeArea()
            VStack{
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                }) {
                    RoundedRectangle(cornerRadius:10)
                        .foregroundColor(.white)
                        .frame(width:50, height:5)
                }
                Spacer()
                    .frame(height:60)
                HStack {
                    Text("관심사")
                        .font(.custom("온글잎 의연체", size:34))
                        .foregroundColor(.PrimaryColor)
                    Text("수정")
                        .font(.custom("온글잎 의연체", size:34))
                        .foregroundColor(.white)
                }
                Text("최소 5개 이상 선택해야 해요!")
                    .font(.custom("온글잎 의연체", size: 22))
                    .foregroundColor((duplicatedkeywords.count < 5) ? Color.red : Color.white)
                Text("\(duplicatedkeywords.count) / 10")
                    .font(.custom("온글잎 의연체", size: 34))
                    .foregroundColor((duplicatedkeywords.count < 5 || duplicatedkeywords.count > 10) ? Color.red : Color.white)
                Spacer()
                    .frame(height:80)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(alignment: .leading){
                        HStack{
                            ForEach(0..<14, id: \.self) { i in
                                    Button(action: {
                                        if tagData.Tags[i].isSelected == true {
                                            tagData.Tags[i].isSelected = false
                                            duplicatedkeywords = duplicatedkeywords.filter{ $0 !=  tagData.Tags[i].index }
                                            
                                        } else {
                                            tagData.Tags[i].isSelected = true
                                            duplicatedkeywords.append(tagData.Tags[i].index)
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
                            ForEach(14..<30, id: \.self) { i in
                                Button(action: {
                                    if tagData.Tags[i].isSelected == true {
                                        tagData.Tags[i].isSelected = false
                                        duplicatedkeywords = duplicatedkeywords.filter{ $0 !=  tagData.Tags[i].index }
                                    } else {
                                        tagData.Tags[i].isSelected = true
                                        duplicatedkeywords.append(tagData.Tags[i].index)
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
                                        duplicatedkeywords = duplicatedkeywords.filter{ $0 !=  tagData.Tags[i].index }
                                    } else {
                                        tagData.Tags[i].isSelected = true
                                        duplicatedkeywords.append(tagData.Tags[i].index)
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
                                        duplicatedkeywords = duplicatedkeywords.filter{ $0 !=  tagData.Tags[i].index }
                                    } else {
                                        tagData.Tags[i].isSelected = true
                                        duplicatedkeywords.append(tagData.Tags[i].index)
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
                                        duplicatedkeywords = duplicatedkeywords.filter{ $0 !=  tagData.Tags[i].index }
                                    } else {
                                        tagData.Tags[i].isSelected = true
                                        duplicatedkeywords.append(tagData.Tags[i].index)
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
                            ForEach(75..<87, id: \.self) { i in
                                Button(action: {
                                    
                                    if tagData.Tags[i].isSelected == true {
                                        tagData.Tags[i].isSelected = false
                                        duplicatedkeywords = duplicatedkeywords.filter{ $0 !=  tagData.Tags[i].index }
                                    } else {
                                        tagData.Tags[i].isSelected = true
                                        duplicatedkeywords.append(tagData.Tags[i].index)
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
                    }.padding([.leading, .trailing], 20)
                }
                Spacer()
                    .frame(height:140)
                HStack{
                    Button{
                        action: do {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } label:{
                        SharedRectangularButton(rectWidth:150, rectColor:.ThirdColor, text:"취소", textColor:.white)
                    }
                    Spacer()
                        .frame(width:20)
                    Button{
                        action: do {
                            keywords = duplicatedkeywords
                            CoreDataManager.coreDM.readKeyword()[0].favorite = keywords
                            CoreDataManager.coreDM.updateProfile()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } label:{
                        SharedRectangularButton(rectWidth:150, rectColor: (keywords.count < 5 || keywords.count > 10) ? .ThirdColor : .PrimaryColor, text:"수정", textColor:(keywords.count < 5 || keywords.count > 10) ? .white : .black)
                    }.disabled(keywords.count < 5 || keywords.count > 10)
                }
                Spacer()
                    .frame(height:20)
            }
        }
        .onAppear {
            duplicatedkeywords = keywords
            for keyword in keywords {
                tagData.Tags[keyword].isSelected = true
            }
        }
    }
}

struct KeywordChangeView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordChangeView(keywords: .constant([1,2,3]))
    }
}
