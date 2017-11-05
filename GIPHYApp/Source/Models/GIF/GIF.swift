//
//  GIF.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/2/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import Foundation
import ObjectMapper

protocol Identifiable {
    var id: String { get }
}

struct GIF: Identifiable, ImmutableMappable {
    let id: String
    let url: URL?
    var localGIFData: Data?
    var query: String?

    init(map: Map) throws {
        id = try map.value("id")
        url = try? map.value("images.fixed_width.url", using: URLTransform())
    }

    func mapping(map: Map) {
        id >>> map["id"]
        url >>> (map["url"], URLTransform())
    }

    init(id: String, url: URL?, localGIFData: Data?, query: String?) {
        self.id = id
        self.url = url
        self.localGIFData = localGIFData
        self.query = query
    }
}

extension GIF: Equatable {
    static func == (lhs: GIF, rhs: GIF) -> Bool {
        return lhs.id == rhs.id
    }
}
