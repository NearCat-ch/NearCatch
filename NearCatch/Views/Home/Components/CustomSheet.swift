//
//  CustomModal.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/10.
//

import SwiftUI

struct CustomSheetPreviewView: View {
    
    @State private var test = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            Button {
                withAnimation(.spring()) {
                    test.toggle()
                }
            } label: {
                Text("시트 업!")
                    .padding(20)
                    .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.white))
            }
        }
        // MARK: 주의!! 최상단 뷰에 넣어줘야 함!
        .customSheet(isPresented: $test) {
            Match(imageData: nil, nickName: "에반", keywords: [1, 2, 3])
        }
    }
}

struct CustomSheet<Content: View>: View {
    
    @Environment(\.horizontalSizeClass) private var horizontal
    @Binding var isPresented: Bool
    let content: () -> Content
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._isPresented = isPresented
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            content()
            
            CircleButton(imageName: "icn_cancle") {
                withAnimation(.spring()) {
                    isPresented = false
                }
            }
            .frame(width: 40, height: 40)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.ThirdColor)
        )
        .padding(20)
    }
}

struct CustomSheetViewModifier<InnerContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    let innerContent: () -> InnerContent
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> InnerContent) {
        self._isPresented = isPresented
        self.innerContent = content
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            ZStack(alignment: .center) {
                if isPresented {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isPresented = false
                            }
                        }
                        .transition(.opacity)
                    
                    CustomSheet(isPresented: $isPresented) {
                        innerContent()
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}

extension View {
    func customSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(CustomSheetViewModifier(isPresented: isPresented, content: content))
    }
}

struct CustomSheetPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        CustomSheetPreviewView()
            .preferredColorScheme(.dark)
    }
}
