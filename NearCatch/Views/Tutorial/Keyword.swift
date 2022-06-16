//
//  Keyword.swift
//  NearCatch
//
//  Created by Tempnixk on 2022/06/16.
//
//

import Foundation
import CoreData

@objc(Keyword)
public class Keyword: NSManagedObject {
   

        @nonobjc public class func fetchRequest() -> NSFetchRequest<Keyword> {
            return NSFetchRequest<Keyword>(entityName: "Keyword")
        }
    @NSManaged public var favorite: [Int]

    }

   

extension Keyword : Identifiable {

}
