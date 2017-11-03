//
//  GIPHYAPIService.swift
//  GIPHYApp
//
//  Created by Daniel Ilchishyn on 11/2/17.
//  Copyright © 2017 KRUBERLICK. All rights reserved.
//

import Foundation
import Siesta
import ObjectMapper
import RxSwift

class GIPHYAPIService: Service, GIPHYAPIServiceProtocol {
    private static let APIKey = "T5JLumVr6Oozwcz1AJV4fuOLcB4MCkVv"
    private static let searchEndpoint = "/gifs/search"

    var search: Resource {
        return resource("/gifs/search")
    }

    init() {
        super.init(baseURL: "https://api.giphy.com/v1")
        configureTransformers()
    }

    private func configureTransformers() {
        configureTransformer(GIPHYAPIService.searchEndpoint) {
            Mapper<GIFSearchResponse>().map(JSON: $0.content)
        }
    }

    func searchGIFs(withQuery query: String, limit: Int, offset: Int) -> Observable<GIFSearchResponse> {
        return Observable.create { observer in
            let request = self.search
                .withParam("api_key", GIPHYAPIService.APIKey)
                .withParam("q", query)
                .withParam("limit", "\(limit)")
                .withParam("offset", "\(offset)")
                .load()
                .onSuccess { response in
                    let response: GIFSearchResponse = response.typedContent()!
                    observer.onNext(response)
                    observer.onCompleted()
                }
                .onFailure { error in
                    observer.onError(error)
            }
            return Disposables.create {
                if !request.isCompleted {
                    request.cancel()
                }
            }
        }
    }
}
