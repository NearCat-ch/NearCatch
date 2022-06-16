//
//  KeywordChangeView.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/14.
//

import SwiftUI

struct KeywordChangeView: View {
    @StateObject var tagData = TagViewModel()
    @ObservedObject var togglecount = ToggleCount()
    @State var tag:Int? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            Image("img_background")
                .edgesIgnoringSafeArea([.top])
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
                    .foregroundColor((togglecount.keywordCounter < 5) ? Color.red : Color.white)
                Text("\(togglecount.keywordCounter) / 10")
                    .font(.custom("온글잎 의연체", size: 34))
                    .foregroundColor((togglecount.keywordCounter < 5 || togglecount.keywordCounter > 10) ? Color.red : Color.white)
                Spacer()
                    .frame(height:80)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(alignment: .leading){
                        HStack{
                            ForEach(0..<14, id: \.self) { i in
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
                    }.padding([.leading, .trailing], 20)
                }
                Spacer()
                    .frame(height:140)
                HStack{
                    Button{
                        action: do { self.presentationMode.wrappedValue.dismiss() }
                    } label:{
                        SharedRectangularButton(rectWidth:150, rectColor:.ThirdColor, text:"취소", textColor:.white)
                    }
                    Spacer()
                        .frame(width:20)
                    Button{
                        action: do { self.presentationMode.wrappedValue.dismiss() }
                    } label:{
                        SharedRectangularButton(rectWidth:150, rectColor: (togglecount.keywordCounter < 5 || togglecount.keywordCounter > 10) ? .ThirdColor : .PrimaryColor, text:"수정", textColor:(togglecount.keywordCounter < 5 || togglecount.keywordCounter > 10) ? .white : .black)
                    }.disabled(togglecount.keywordCounter < 5 || togglecount.keywordCounter > 10)
                }
                Spacer()
                    .frame(height:20)
            }
        }
    }
}

struct KeywordChangeView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordChangeView()
    }
}
