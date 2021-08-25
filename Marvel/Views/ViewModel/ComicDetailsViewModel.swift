//
//  ComicDetailsViewModel.swift
//  Marvel
//
//  Created by Tony Nlemadim on 12/18/19.
//  Copyright © 2019 Tony Nlemadim. All rights reserved.
//

import Foundation

class ComicDetailsViewModel {
    
    private var selectedComic: Result?
    
    init(_ selectedComic: Result) {
        self.selectedComic = selectedComic
    }
    
    func getSelectedComic() -> Result? {
        return self.selectedComic
    }
}
