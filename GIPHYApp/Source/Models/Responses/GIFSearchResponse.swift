//
//  GIFSearchResponse.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/2/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import Foundation
import ObjectMapper

struct GIFSearchResponse: ImmutableMappable {
    struct Meta: ImmutableMappable {
        let status: Int
        let message: String

        init(map: Map) throws {
            status = try map.value("status")
            message = try map.value("msg")
        }
    }
    struct Pagination: ImmutableMappable {
        let totalCount: Int
        let count: Int
        let offset: Int

        init(map: Map) throws {
            totalCount = try map.value("total_count")
            count = try map.value("count")
            offset = try map.value("offset")
        }
    }

    let data: [GIF]
    let meta: Meta
    let pagination: Pagination

    init(map: Map) throws {
        data = (try? map.value("data")) ?? []
        meta = try map.value("meta")
        pagination = try map.value("pagination")
    }
}
