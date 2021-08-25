//
//  APIConfiguration.swift
//  Marvel
//
//  Created by Tony Nlemadim on 11/30/19.
//  Copyright © 2019 Tony Nlemadim. All rights reserved.
//

import Foundation

class APIConfiguration: NSObject {
    // Base URL to make API calls
    var baseURL = ""
    var apiKey = ""
    
    override init() {
        if let baseURL = Utility.getPlistValue(forkey: Plist.baseURL),
            let apiKey = Utility.getPlistValue(forkey: Plist.apiKey) {
            self.baseURL = baseURL
            self.apiKey = "\(Plist.apiKey)=" + apiKey
        }
    }
    
    private func getServiceURL(type: String) -> String {
        return baseURL + APIConstants.prefix + type + apiKey
    }
    
    private func getURLString(type: String, queryParam: String) -> String {
        return  "\(getServiceURL(type: type + "?"))&" + queryParam
    }
    
    // API Endpoints
    enum Endpoint {
        case getEvent(eventId: String)
        case getComics
        case getCharacters
        
        func methodType() -> String {
            switch self {
            case
            .getEvent,
            .getComics,
            .getCharacters:
                return Server.getRequest
            }
        }
    }
    
    func getEndpointURL(_ endpoint: Endpoint) -> String {
        switch endpoint {
        case .getEvent(let eventId):
            return getURLString(type: "" + eventId, queryParam: "")
        case .getComics:
            return getURLString(type: MetaData.comic, queryParam: getHash())
        case .getCharacters:
            return getURLString(type: "", queryParam: "")
        }
    }
    
    private func getHash() -> String {
        guard let privateKey = Utility.getPlistValue(forkey: Plist.privateKey),
        let publicKey = Utility.getPlistValue(forkey: Plist.apiKey),
            let timeStamp = Utility.getPlistValue(forkey: Plist.timeStamp) else { return "" }
        let hashedValue = Utility.MD5(string: (timeStamp + privateKey + publicKey))
        return ("\(Plist.hash)=\(hashedValue)\("&")\(Plist.timeStamp)=\(timeStamp)")
    }
}

