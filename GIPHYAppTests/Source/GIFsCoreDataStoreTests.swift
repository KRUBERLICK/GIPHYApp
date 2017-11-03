//
//  GIFsCoreDataStoreTests.swift
//  GIPHYAppTests
//
//  Created by Daniel Ilchishyn on 11/2/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import XCTest
@testable import GIPHYApp

class GIFsCoreDataStoreTests: XCTestCase {
    private var store: GIFsCoreDataStore!
    
    override func setUp() {
        super.setUp()
        store = GIFsCoreDataStore(localURLProvider: LocalURLProvider())
    }
    
    override func tearDown() {
        super.tearDown()
        _ = store.clearStore().subscribe()
    }

    private func clearStore(withExpectation expectation: XCTestExpectation?, completion: ((Bool) -> ())?) {
        _ = store.clearStore()
            .subscribe(onNext: { result in
                expectation?.fulfill()
                completion?(result)
            }, onError: { error in
                XCTFail(error.localizedDescription)
            })
    }

    private func addGIFToStore(_ gif: GIF, expectation: XCTestExpectation?, completion: ((Bool) -> ())?) {
        _ = store.addGIF(gif)
            .subscribe(onNext: { result in
                expectation?.fulfill()
                completion?(result)
            }, onError: { error in
                XCTFail(error.localizedDescription)
            })
    }

    private func fetchGIFsAndTestCondition(_ condition: @escaping ([GIF]) -> Bool, expectation: XCTestExpectation?) {
        _ = store.fetchGIFs()
            .subscribe(onNext: { results in
                XCTAssertTrue(condition(results))
                expectation?.fulfill()
            }, onError: { error in
                XCTFail(error.localizedDescription)
            })
    }

    func testStoreClear() {
        let expectation = XCTestExpectation(description: "Performing store clear")
        clearStore(withExpectation: expectation, completion: nil)
        wait(for: [expectation], timeout: 10)
    }

    func testGIFAdd() {
        let expectation = XCTestExpectation(description: "Adding new GIF to the store")
        let gif = GIF(id: "12345", url: nil, localURL: nil)
        addGIFToStore(gif, expectation: nil, completion: { _ in
            self.fetchGIFsAndTestCondition({ $0.count == 1 && $0[0].id == gif.id }, expectation: expectation)
        })
        wait(for: [expectation], timeout: 10)
    }

    func testGIFDelete() {
        let expectation = XCTestExpectation(description: "Deleting GIF from the store")
        let gif = GIF(id: "12345", url: nil, localURL: nil)
        addGIFToStore(gif, expectation: nil, completion: { _ in
            _ = self.store.deleteGIF(withID: gif.id)
                .subscribe(onNext: { _ in
                    self.fetchGIFsAndTestCondition({ $0.isEmpty }, expectation: expectation)
                }, onError: { error in
                    XCTFail(error.localizedDescription)
                })
        })
        wait(for: [expectation], timeout: 10)
    }

    func testGIFUpdate() {
        let expectation = XCTestExpectation(description: "Performing GIF update")
        let gif = GIF(id: "12345", url: nil, localURL: nil)
        addGIFToStore(gif, expectation: nil, completion: { _ in
            let url = URL(string: "https://google.com")!
            let updatedGIF = GIF(id: gif.id, url: url, localURL: gif.localURL)
            _ = self.store.updateGIF(updatedGIF)
                .subscribe(onNext: { _ in
                    self.fetchGIFsAndTestCondition({ $0.count == 1 && $0[0].id == updatedGIF.id && $0[0].url == updatedGIF.url }, expectation: expectation)
                }, onError: { error in
                    XCTFail(error.localizedDescription)
                })
        })
        wait(for: [expectation], timeout: 10)
    }
}
