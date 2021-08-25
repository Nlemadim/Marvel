//
//  ComicApi.swift
//  Marvel
//
//  Created by Tony Nlemadim on 12/2/19.
//  Copyright © 2019 Tony Nlemadim. All rights reserved.
//

import Foundation

final class ComicApi {
    
    typealias comicCompletionHandler = (ComicModel?, APIError?) -> Void
    
    static func getComic(completion: @escaping comicCompletionHandler) {
        APIManager.shared.apiCall(forEndpoint: .getComics) { (data, statusCode, error) in
            if let data = data, statusCode.isSuccessHTTPCode, error == nil, let comicModel = try? JSONDecoder().decode(ComicModel.self, from: data) {
                completion(comicModel, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
