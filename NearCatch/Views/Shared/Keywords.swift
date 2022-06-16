//
//  Keywords.swift
//  NearCatch
//
//  Created by Wonhyuk Choi on 2022/06/16.
//  ref : https://www.youtube.com/watch?v=4UcShbcJUU0
//

import SwiftUI

struct Keywords: View {
    var tagData : TagViewModel
    var tags : [Tag]
    
    init() {
        tagData = TagViewModel()
        tags = []
        for i in 0...9 {
            tags.append(tagData.Tags[i])
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ForEach(getRows(), id: \.self) { rows in
                HStack(alignment: .center, spacing: 5) {
                    ForEach(rows) { row in
                        Text(row.name)
                            .font(.custom("온글잎 의연체", size: 22))
                            .tagView(.black, .PrimaryColor)
                    }
                }
            }
        }
    }
    
    func getRows()->[[Tag]] {
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        var totalWidth: CGFloat = 0
        
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 10
        
        tags.forEach { tag in
            let font = UIFont.systemFont(ofSize: 30)
            let attributes = [NSAttributedString.Key.font: font]
            let size = (tag.name as NSString).size(withAttributes: attributes)
            
            totalWidth += size.width
            
            if totalWidth > screenWidth {
                rows.append(currentRow)
                currentRow.removeAll()
                currentRow.append(tag)
                totalWidth = size.width
            } else {
                currentRow.append(tag)
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
            currentRow.removeAll()
        }
        
        return rows
    }
}

struct Keywords_Previews: PreviewProvider {
    static var previews: some View {
        Keywords()
    }
}
