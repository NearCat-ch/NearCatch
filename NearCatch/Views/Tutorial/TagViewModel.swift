//
//  TagViewModel.swift
//  NearCatch
//
//  Created by Tempnixk on 2022/06/13.
//

import SwiftUI

struct Tag {
    var index: Int
    var name: String
    var isSelected: Bool = false
    // var color = isSelected true ? Color.PrimaryColor : Color.SecondaryColor
    // var size: Double
}

class ToggleCount: ObservableObject {
    @Published var keywordCounter: Int = 0
}
