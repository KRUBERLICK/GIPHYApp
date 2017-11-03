//
//  GIFsCache.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/3/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import Foundation
import Alamofire

class GIFsCache: GIFsCacheProtocol {
    private let localStore: GIFsStoreProtocol
    private let localURLProvider: LocalURLProvider

    init(localStore: GIFsStoreProtocol, localURLProvider: LocalURLProvider) {
        self.localStore = localStore
        self.localURLProvider = localURLProvider
    }

    func cacheGIF(_ gif: GIF) {
        guard let remoteURL = gif.url else {
            return
        }
        let localFileURL = localURLProvider.gifDataCacheDirectory.appendingPathComponent(gif.id)
        let downloadDestination: DownloadRequest.DownloadFileDestination = { _, _ in
            (localFileURL, [.removePreviousFile])
        }
        Alamofire.download(remoteURL, to: downloadDestination).response { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            if let error = response.error {
                print("Error downloading GIF: \(error)")
                return
            }
            let updatedGIF = GIF(id: gif.id, url: gif.url, localURL: localFileURL)
            _ = strongSelf.localStore.updateGIF(updatedGIF).subscribe()
        }
    }

    func removeCachedGIF(_ gif: GIF) {
        guard let localURL = gif.localURL, FileManager.default.fileExists(atPath: localURL.path) else {
            return
        }
        do {
            try FileManager.default.removeItem(at: localURL)
        } catch let error {
            print("Error removing GIF from cache: \(error)")
        }
        let updatedGIF = GIF(id: gif.id, url: gif.url, localURL: nil)
        _ = localStore.updateGIF(updatedGIF).subscribe()
    }
}
