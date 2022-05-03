//
//  URLProtocolMock.swift
//  Music BrowserTests
//
//  Created by Angelina on 03.05.22.
//

import Foundation

@testable import Music_Browser

@objc
class URLProtocolMock: URLProtocol {

    static var testURLs = [URL?: Data]()
    static var response: URLResponse?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canInit(with task: URLSessionTask) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let url = request.url, let data = URLProtocolMock.testURLs[url] {
            client?.urlProtocol(self, didLoad: data)
        }

        if let response = URLProtocolMock.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let error = URLProtocolMock.error {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
