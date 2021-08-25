//
//  ComicViewModel.swift
//  Marvel
//
//  Created by Tony Nlemadim on 12/3/19.
//  Copyright © 2019 Tony Nlemadim. All rights reserved.
//

import Foundation

class ComicViewModel {

    private var comicData: ComicModel?
    
    init() {}

    func getComicDataSource() -> [Result] {
        return comicData?.data.results ?? []
    }
    
    func loadComicData(completion: @escaping(APIError?) -> Void) {
        ComicApi.getComic {[weak self] comicData, error in
            guard error == nil else {
                completion(error)
                return
            }
            if let comicData = comicData {
            self?.comicData = comicData
            }
            completion(nil)
        }
    }
}

