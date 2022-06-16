//
//  ImagePickerModel.swift
//  NearCatch
//
//  Created by ryu hyunsun on 2022/06/15.
//

import Foundation
import UIKit
import PhotosUI

struct Imgs: Hashable {
    var images: [Img]
}

struct Img: Hashable {
    let id = UUID()
    var image: UIImage
    var selected: Bool
    var asset: PHAsset
}
