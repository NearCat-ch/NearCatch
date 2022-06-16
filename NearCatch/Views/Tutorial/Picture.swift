//
//  Picture.swift
//  NearCatch
//
//  Created by Tempnixk on 2022/06/16.
//

import Foundation
import CoreData
import UIKit

@objc (Picture)
class Picture: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture")
    }
    
    @NSManaged public var content: UIImage?
    @NSManaged public var title: String?
}

extension Picture : Identifiable {
    
}
