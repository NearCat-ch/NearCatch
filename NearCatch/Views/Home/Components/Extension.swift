//
//  Extensions.swift
//  NearCatch
//
//  Created by 김예훈 on 2022/06/10.
//

import SwiftUI

// 임시 상태
enum GameState: String {
    case ready
    case finding
    case found
}

extension String {
    
    func partialColor(basicColor: Color = .primary, _ partials: [String], _ color: Color) -> AttributedString {
        var string = AttributedString(self)
        string.foregroundColor = basicColor
        
        for partial in partials {
            if let range = string.range(of: partial) {
                string[range].foregroundColor = color
            }
        }
        
        return string
    }
}
