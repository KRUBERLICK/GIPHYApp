//
//  GIFsStoreProtocol.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/2/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import Foundation
import RxSwift

protocol GIFsStoreProtocol {
    func fetchGIFs() -> Observable<[GIF]>
    func fetchGIFs(withQuery query: String) -> Observable<[GIF]>
    func addGIF(_ gif: GIF) -> Observable<Bool>
    func deleteGIF(withID gifID: String) -> Observable<Bool>
    func updateGIF(_ gif: GIF) -> Observable<Bool>
    func clearStore() -> Observable<Bool>
}
