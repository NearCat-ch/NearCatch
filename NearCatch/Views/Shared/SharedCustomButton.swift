//
//  SharedCustomButton.swift
//  NearCatch
//
//  Created by HWANG-C-K on 2022/06/09.
//

import SwiftUI

struct SharedCustomButton: View {
    @State var icon:String
    @State var circleSize:CGFloat
    @State var color:Color
    var body: some View {
        ZStack{
            ZStack{
                Circle()
                    .fill(Color.white)
                    .opacity(0.3)
                    .frame(width:circleSize * 1.2, height:circleSize*1.2)
                Circle()
                    .fill(color)
                    .opacity(0.5)
                    .frame(width:circleSize, height:circleSize)
                Image(icon)
            }
        }
    }
}

struct SharedCustomButton_Previews: PreviewProvider {
    static var previews: some View {
        SharedCustomButton(icon: "icn_edit", circleSize: 50, color:Color.white)
    }
}
