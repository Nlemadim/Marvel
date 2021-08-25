//
//  APIManager.swift
//  Marvel
//
//  Created by Tony Nlemadim on 11/30/19.
//  Copyright © 2019 Tony Nlemadim. All rights reserved.
//

import Foundation

/**
 Use the APIManager singleton to make API calls
 */
class APIManager: NSObject {
    static let shared = APIManager()
    private var apiConfiguration = APIConfiguration()
    
    /// Default duration in seconds to wait for API call response
    private let timeOutInterval = 30.0
    typealias ResponseHandler = (_ value: Data?, _ statusCode: Int, _ apiError: APIError?) -> Void
    
    private override init() {}
    
    func apiCall(forEndpoint endpoint: APIConfiguration.Endpoint,
                 parameters: [String: Any]? = nil,
                 httpHeaders: [String: String]? = nil,
                 _ completion: ResponseHandler?) {
        
        var body: Data?
        if let parameters = parameters {
            guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                completion?(nil, 0, APIError.internalError("Invalid Parameters: \n\(parameters)"))
                return
            }
            body = postData
        }
        apiCall(forEndpoint: endpoint, body: body, httpHeaders: httpHeaders, completion)
    }
    /// Make an API Call for a given endpoint
    ///
    /// - Parameters:
    ///     - forEndpoint: The enpoint type used to make call
    ///     - body: optional Data value that will be send in the request body as a JSON
    ///     - httpHeaders: optional dictionary for aditional HTTP headers that will be used in the request.
    ///     - completion: The callback called after retrieval.
    func apiCall(forEndpoint endpoint: APIConfiguration.Endpoint,
                 body: Data?,
                 httpHeaders: [String: String]?,
                 _ completion: ResponseHandler?) {
        
        self.performRequest(forEndpoint: endpoint, body: body, httpHeaders: httpHeaders, token: "", completion)
        
    }
    
    private func performRequest(forEndpoint endpoint: APIConfiguration.Endpoint, body: Data?,
                                httpHeaders: [String: String]?, token: String,
                                _ completion: ResponseHandler?) {
        
        // Check internet connection
        guard Reachability.isConnectedToNetwork() else {
            completion?(nil, 0, APIError.internetConection)
            return
        }
        
        // URLSession
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        let urlSession = URLSession(configuration: sessionConfiguration)
        
        // URL
        let urlString = apiConfiguration.getEndpointURL(endpoint)
        
        guard let url = URL(string: urlString) else {
            completion?(nil, 0, APIError.internalError("Incorrect endpoint format: \(urlString)"))
            return
        }
        // URLRequest
        var headers = ["Content-Type": "application/json",
                       "Accept": "*/*"]
        //Out of Scope
        if !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.timeoutInterval = timeOutInterval
        urlRequest.cachePolicy = .useProtocolCachePolicy
        urlRequest.httpMethod = endpoint.methodType()
        
        if let httpHeaders = httpHeaders {
            for (key, value) in httpHeaders {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Parameters
        if let body = body {
            urlRequest.httpBody = body
        }
        // URL Data task
        switch endpoint {
        default:
            startTaskWithCompletionHandler(urlSession: urlSession, urlRequest: urlRequest, token: token, completion, endpoint: endpoint, body: body, httpHeaders: httpHeaders)
        }
    }
    
    private func startTaskWithCompletionHandler(urlSession: URLSession, urlRequest: URLRequest, token: String, _ completion: ResponseHandler?,
                                                endpoint: APIConfiguration.Endpoint, body: Data?, httpHeaders: [String: String]?) {
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            self.printRequest(urlRequest)
            self.printResponseStatus(data: data, response: response, error: error)
            var statusCode: Int?
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
            }
            //basic connectivity error
            if let error = error as NSError? {
                Utility.print("Error: \(error.localizedDescription)")
                completion?(nil, statusCode ?? 0, APIError.unknownError)
                return
            }
            //check if status code is success
            if statusCode?.isSuccessHTTPCode ?? false {
                if let data = data {
                    completion?(data, statusCode ?? 0, nil)
                } else {
                    Utility.print("=======Status code is fine but data is nil===========")
                }
            } else {
                //status code is 400, 500, 501 etc
                completion?(nil, statusCode ?? 0, APIError.serverError(statusCode ?? 0, "", urlRequest.httpMethod))
            }
        }.resume()
    }
    
    private func printResponseStatus(data: Data?, response: URLResponse?, error: Error?) {
        var string = "=============="
        string.append("\nAPI RESPONSE")
        string.append("\nURL: \(response?.url?.absoluteString ?? "")")
        
        if let httpResponse = response as? HTTPURLResponse {
            string.append("\nSTATUS CODE: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode >= 300, let data = data {
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] ?? [:]
                string.append("\nDATA: \n\(jsonData?.jsonDescription ?? "")")
            } else if let data = data, ProcessInfo.processInfo.environment["logFullAPIResponses"] != nil {
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] ?? [:]
                string.append("\nDATA: \n\(jsonData?.jsonDescription ?? "")")
            } else {
                string.append("\nDATA AVAILABLE: \(data != nil)")
            }
        }
        
        if let error = error {
            let nsError = error as NSError
            string.append("\nERROR CODE: \(nsError.code)")
            string.append("\nERROR DESCRIPTION: \(nsError.description)")
        }
        
        string.append("\n==============")
        Utility.print(string)
    }
    
    private func printRequest(_ request: URLRequest) {
        var string = "=============="
        string.append("\nAPI CALL")
        string.append("\nURL: \(request.url?.absoluteString ?? "")")
        string.append("\nMETHOD: \(request.httpMethod ?? "")")
        string.append("\nHEADERS: \n\((request.allHTTPHeaderFields ?? [:]).jsonDescription)")
        
        if let data = request.httpBody {
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] ?? [:]
            string.append("\nBODY: \n\(jsonData?.jsonDescription ?? "")")
        }
        string.append("\n==============")
        Utility.print(string)
    }
}
