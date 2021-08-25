//
//  MarvelTests.swift
//  MarvelTests
//
//  Created by Tony Nlemadim on 11/30/19.
//  Copyright © 2019 Tony Nlemadim. All rights reserved.
//

import XCTest
@testable import Marvel

class MarvelTests: XCTestCase {
    typealias Endpoint = APIConfiguration.Endpoint

    override func tearDown() {
        super.tearDown()
    }

    func testGetEndpointsMethodType() {
        checkMethodType(.getCharacters, type: Server.getRequest)
        checkMethodType(.getEvent(eventId: "1"), type: Server.getRequest)
        checkMethodType(.getComics, type: Server.getRequest)
    }
    
    func checkMethodType(_ endpoint: APIConfiguration.Endpoint, type: String) {
        XCTAssertEqual(endpoint.methodType(), type, "\(endpoint) method type must be \(type)")
    }
}
