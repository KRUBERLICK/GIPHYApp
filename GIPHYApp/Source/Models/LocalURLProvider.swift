//
//  LocalURLProvider.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/2/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import Foundation

struct LocalURLProvider {
    var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    var gifDataCacheDirectory: URL {
        let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let gifDataCacheURL = cachesDirectoryURL.appendingPathComponent("CachedGIFs")
        if !FileManager.default.fileExists(atPath: gifDataCacheURL.path) {
            do {
                try FileManager.default.createDirectory(at: gifDataCacheURL, withIntermediateDirectories: false, attributes: nil)
            } catch let error {
                fatalError("Cannot create GIF cache directory: \(error)")
            }
        }
        return gifDataCacheURL
    }
}
