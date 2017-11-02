//
//  ManagedGIF+CoreDataProperties.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/2/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//
//

import Foundation
import CoreData

extension ManagedGIF {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedGIF> {
        return NSFetchRequest<ManagedGIF>(entityName: "ManagedGIF")
    }

    @NSManaged public var id: String?
    @NSManaged public var url: URL?
    @NSManaged public var localGIFData: NSData?
}
