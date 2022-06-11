//
//  NearCat.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/10.
//

import SwiftUI

struct NearCat: View {
    
    @Binding var state: GameState
    
    var body: some View {
        switch state {
        case .ready:
            EmptyView()
        case .finding:
            Image("img_serch_60px")
        case .found:
            Image("img_hurray")
        }
    }
}

struct NearCat_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 50) {
            NearCat(state: .constant(.ready))
            
            NearCat(state: .constant(.finding))
            
            NearCat(state: .constant(.found))
        }
        .padding(20)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
