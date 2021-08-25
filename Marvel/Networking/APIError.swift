//
//  APIError.swift
//  Marvel
//
//  Created by Tony Nlemadim on 11/30/19.
//  Copyright © 2019 Tony Nlemadim. All rights reserved.
//

import Foundation

enum APIError: Error {
    case internalError(String)
    case serverError(Int, String, String?)
    case internetConection
    case unknownError
    case authError
}
