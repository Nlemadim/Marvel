//
//  MarvelModel.swift
//  Marvel
//
//  Created by Tony Nlemadim on 11/30/19.
//  Copyright © 2019 Tony Nlemadim. All rights reserved.
//

import Foundation
// MARK: - SuccessResponse
struct ComicModel: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let id: Int
    let title, resultDescription: String?
    let prices: [Price]
    let thumbnail: Thumbnail
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case resultDescription = "description"
        case prices, thumbnail
    }
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: Extension
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

enum Extension: String, Codable {
    case jpg = "jpg"
}

// MARK: - Price
struct Price: Codable {
    let price: Double
}
