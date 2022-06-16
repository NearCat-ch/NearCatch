//
//  ImageView.swift
//  NearCatch
//
//  Created by ryu hyunsun on 2022/06/15.
//


import SwiftUI
import PhotosUI
struct ImageView: View {
    @Binding var data: Img
    @Binding var tempImage: Img?
    @Binding var grid : [Img]
    
    var body: some View {
        ZStack {
            Image(uiImage: self.data.image)
                
                .resizable()
//                .frame(height: 150)
//                .scaledToFit()
            if self.data.selected{
                
                ZStack{
                    
                    Color.white.opacity(0.3)
                    VStack(alignment: .trailing){
                        Spacer()
                        HStack{
                            Spacer()
                            ZStack{
                                Circle()
                                    .strokeBorder(.white,lineWidth: 2)
                                        .background(Circle().foregroundColor(Color(red: 0, green: 122/255, blue: 255/255)))
                                
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 15, height: 15)
                            }
                            .frame(width: 30, height: 30)
                            .padding(.bottom,5)
                            .padding(.trailing,5)
                        }
                        
                        
                    }
                    
                }
            }
            
            
        }
//        .frame(width: 100, height: 100)
        .onTapGesture {

            
            if !self.data.selected {
                for i in (0..<self.grid.count) {
                    self.grid[i].selected = false
                }
                
                
                self.data.selected = true
                
                DispatchQueue.global(qos: .background).async {
                    let options = PHImageRequestOptions()
                    options.isSynchronous = true
                    PHCachingImageManager.default().requestImage(for: self.data.asset, targetSize: .init(), contentMode: .default, options: options) { (image, _) in

                        self.tempImage = Img(image: image!, selected: true, asset: self.data.asset)
                    }
                }
            }
        }
    }
}
//
//struct Card_Previews: PreviewProvider {
//    static var previews: some View {
//        Card()
//    }
//}
