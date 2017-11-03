//
//  GIPHYApiServiceProtocol.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/3/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import Foundation
import RxSwift

protocol GIPHYAPIServiceProtocol {
    func searchGIFs(withQuery query: String, limit: Int, offset: Int) -> Observable<GIFSearchResponse>
}
