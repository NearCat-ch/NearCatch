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
            Image("img_hurray")
        case .finding, .found:
            Image("img_serch_60px")
        }
    }
}

struct NearCat_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NearCat(state: .constant(.ready))
            
            NearCat(state: .constant(.finding))
        }
        .padding(20)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
