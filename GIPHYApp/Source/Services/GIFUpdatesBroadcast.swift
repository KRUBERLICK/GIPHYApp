//
//  GIFUpdatesBroadcast.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/3/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GIFUpdatesBroadcast {
    let updates = PublishSubject<GIF>()

    func update(gif: GIF) {
        updates.onNext(gif)
    }
}
