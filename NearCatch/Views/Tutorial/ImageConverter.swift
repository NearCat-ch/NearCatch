//
//  ImageConverter.swift
//  NearCatch
//
//  Created by ryu hyunsun on 2022/06/17.
//

import UIKit

struct ImageConverter{

    static func resize(image: UIImage)-> UIImage{
        let size = CGSize(width: 300, height: 300)
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { context in
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        return resizedImage
    }
}
