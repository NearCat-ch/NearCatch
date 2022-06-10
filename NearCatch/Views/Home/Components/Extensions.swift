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

extension Color {
    
    static let theme = ColorTheme()
    
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct ColorTheme {
    let yellow = Color(hex: 0xFFEC6C)
    let background = Color(hex: 0x00254B)
}
