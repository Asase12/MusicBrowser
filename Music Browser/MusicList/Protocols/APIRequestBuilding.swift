//
//  APIRequestBuilding.swift
//  Music Browser
//
//  Created by Angelina on 03.05.22.
//

import Foundation

protocol APIRequestBuilding {
    func buildRequest(from url: URL,
                      httpMethod: String,
                      headers: [String : String],
                      httpBody: Data?) -> URLRequest
}

extension APIRequestBuilding {

    func buildRequest(from url: URL,
                      httpMethod: String = "GET",
                      headers: [String : String] = [:],
                      httpBody: Data? = nil) -> URLRequest {

        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = httpMethod
        urlRequest.httpBody = httpBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
