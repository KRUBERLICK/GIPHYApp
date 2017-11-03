//
//  ManagedGIF+CoreDataClass.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/2/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//
//

import Foundation
import CoreData

public class ManagedGIF: NSManagedObject {
    func toGIF() -> GIF {
        return GIF(id: id!, url: url, localURL: localURL)
    }

    func fromGIF(_ gif: GIF) {
        id = gif.id
        url = gif.url
        localURL = gif.localURL
    }
}
