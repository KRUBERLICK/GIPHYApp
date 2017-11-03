//
//  BrowseGIFsWorker.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/2/17.
//  Copyright (c) 2017 KRUBERLICK. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class BrowseGIFsWorker {
    private let cache: GIFsCacheProtocol
    private let localStore: GIFsStoreProtocol
    private let webService: GIPHYAPIServiceProtocol
    private let localURLProvider: LocalURLProvider
    let contents = Variable<[GIF]>([])
    var query: String = ""
    private var disposeBag = DisposeBag()
    private var currentOffset = 0
    private var currentLimit = 20
    private var totalCount = 0
    private var fetchInProgress = false

    init(cache: GIFsCacheProtocol, localStore: GIFsStoreProtocol, webService: GIPHYAPIServiceProtocol, localURLProvider: LocalURLProvider) {
        self.cache = cache
        self.localStore = localStore
        self.webService = webService
        self.localURLProvider = localURLProvider
    }

    func reloadFeed() {
        currentOffset = 0
        if query.isEmpty {
            localStore.fetchGIFs()
                .subscribe(onNext: { [weak self] results in
                    self?.contents.value = results
                })
                .disposed(by: disposeBag)
        }
        else {
            _requestNextChunk(shouldReplaceContents: true)
        }
    }

    func requestNextChunk() {
        guard currentOffset < totalCount else {
            return
        }
        _requestNextChunk(shouldReplaceContents: false)
    }

    private func _requestNextChunk(shouldReplaceContents: Bool) {
        guard shouldReplaceContents || !fetchInProgress else {
            return
        }
        fetchInProgress = true
        disposeBag = DisposeBag()
        webService.searchGIFs(withQuery: query, limit: currentLimit, offset: currentOffset)
            .subscribe(onNext: { [weak self] response in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.totalCount = response.pagination.totalCount
                strongSelf.currentOffset += strongSelf.currentLimit
                if shouldReplaceContents {
                    _ = strongSelf.localStore.fetchGIFs()
                        .subscribe(onNext: { [weak self] results in
                            guard let strongSelf = self else {
                                return
                            }
                            for gif in results {
                                strongSelf.cache.removeCachedGIF(gif)
                            }
                            _ = strongSelf.localStore.clearStore().subscribe()
                        })
                    strongSelf.contents.value = response.data
                }
                else {
                    strongSelf.contents.value += response.data
                }
                for gif in response.data {
                    _ = strongSelf.localStore.addGIF(gif).subscribe()
                }
                strongSelf.fetchInProgress = false
            }, onError: { [weak self] error in
                print("Error during fetch: \(error)")
                self?.fetchInProgress = false
            })
            .disposed(by: disposeBag)
    }

    func cacheGIFData(for gif: GIF) {
        cache.cacheGIF(gif)
    }
}
