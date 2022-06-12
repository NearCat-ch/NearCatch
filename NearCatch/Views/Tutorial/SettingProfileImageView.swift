//
//  SettingProfileImageView.swift
//  NearCatch
//
//  Created by ryu hyunsun on 2022/06/11.
//

import SwiftUI
import PhotosUI

struct SettingProfileImageView: View {
    @Binding var profileimage: Image?
    
    // show
    @State var showImagePicker: Bool = false
    @State private var inputImage: UIImage?
    @State var checkPermission: Bool = false
    
    @State var isPresented = false
    @State var imageWasImported = false
    
    var inlineColorText: AttributedString = partialColorString(allString:"재간둥이 니어캣", allStringColor:.white,partialString:"니어캣",partialStringColor:Color(red: 255/255, green: 236/255, blue: 108/255))
    let accessLevel: PHAccessLevel = .readWrite
    
    var body: some View {
        VStack{
            Text("당신의 사진을 등록해 주세요!")
                .foregroundColor(Color(red: 255/255, green: 236/255, blue: 108/255))
                .font(.custom("온글잎 의연체", size: 34))
                .padding(.top, 45)
                .padding(.bottom, 10)
            Text("프로필 사진은 선택 항목입니다.")
                .foregroundColor(.white)
                .font(.custom("온글잎 의연체", size: 24))
            Text("미입력시 기본 프로필이 제공됩니다.")
                .foregroundColor(.white)
                .font(.custom("온글잎 의연체", size: 24))
            
            // 이미지 클릭 버튼
            Button(action: {
                
                let accessLevel: PHAccessLevel = .readWrite
                let status = PHPhotoLibrary.authorizationStatus(for: accessLevel)
                switch status {
                case .authorized:
                    break
                case .limited:
                    print("limited")
                    break
                case .denied:
                    print("denied")
                    break
                case .notDetermined:
                    print("notDetermined")
                    PHPhotoLibrary.requestAuthorization { authorizationStatus in
                        switch authorizationStatus {
                        case .limited:
                            break
                        case .authorized:
                            print("authorization granted")
                            break
                        case .denied:
                            print("denied")
                            break
                        default:
                            print("Unimplemented")
                            break
                        }
                    }
                    break
                default:
                    break
                }
                
                
//                if checkPermission{
                withAnimation{
                    self.showImagePicker.toggle()
                }
//                }
                
            }) {
                if self.profileimage == nil {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.3))
                        Circle()
                            .fill(.white)
                            .frame(width: 200, height: 200)
                        VStack{
                            Image("icn_img")
                        }
                    }
                    .frame(width: 215, height: 215)
                    .padding(.top, 25)
                }
                else {
                    ZStack{
                        Circle()
                            .fill(.white.opacity(0.3))
                        self.profileimage?
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 200, height: 200)
                    }.frame(width: 215, height: 215)
                        .padding(.top, 25)
                }
            }
            
            
            
            Text("기본 프로필")
                .foregroundColor(.white)
                .font(.custom("온글잎 의연체", size: 22))
            Text(inlineColorText)
                .font(.custom("온글잎 의연체", size: 22))
            
            
        }
        .onChange(of: inputImage) { _ in loadImage() }
        .sheet(isPresented: $showImagePicker) {
//            ImagePicker(imageToImport: $inputImage, isPresented: $isPresented, imageWasImported: $imageWasImported)
//            OpenGallary(isShown: $showImagePicker, image: $profileimage)
        }
        
    }
    
    
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        profileimage = Image(uiImage: inputImage)
    }
}


func partialColorString(allString: String,allStringColor: Color ,partialString: String, partialStringColor: Color ) -> AttributedString {
    var string = AttributedString(allString)
    string.foregroundColor = allStringColor
    
    if let range = string.range(of: partialString) {
        string[range].foregroundColor = partialStringColor
    }
    return string
}

    
    
struct SettingProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        SettingProfileImageView(profileimage: .constant(nil))
    }
}
