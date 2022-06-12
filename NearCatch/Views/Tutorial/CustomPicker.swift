//
//  CustomPicker.swift
//  NearCatch
//
//  Created by ryu hyunsun on 2022/06/12.
//

import SwiftUI
import Photos

struct Images: Hashable {
    
    var image : UIImage
    var selected : Bool
    var asset : PHAsset
}

struct CustomPicker: View {
    
//    @Binding var selected: [SelectedImages]
    @Binding var showImagePicker: Bool
    @State var grid: [[Images]] = []
    @State var disabled = false
    
    
    var body: some View {
        GeometryReader{ _ in
            VStack {
                
            }
            
            
        }
    }
}
//
//struct CustomPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomPicker()
//    }
//}
