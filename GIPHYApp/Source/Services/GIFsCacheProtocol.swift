//
//  GIFsCacheProtocol.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/3/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import Foundation

protocol GIFsCacheProtocol {
    func cacheGIF(_ gif: GIF)
    func removeCachedGIF(_ gif: GIF)
}
