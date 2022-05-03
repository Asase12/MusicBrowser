//
//  Fixtures.swift
//  Music BrowserTests
//
//  Created by Angelina on 03.05.22.
//

import Foundation

@testable import Music_Browser

struct Fixtures {

    static var fakeItems: [MusicItem] {
        [
            MusicItem(id: "10",
                      album: "album 0",
                      artist: "artist 0",
                      label: "label 0",
                      coverUrlString: "url 0",
                      tracks: ["track 00"],
                      year: "1990"),

            MusicItem(id: "11",
                      album: "some album 1",
                      artist: "artist 1",
                      label: "label 1",
                      coverUrlString: "url 1",
                      tracks: ["track 01", "some track"],
                      year: "2001"),

            MusicItem(id: "12",
                      album: "last album 2",
                      artist: "artist 2",
                      label: "label 2",
                      coverUrlString: "url 2",
                      tracks: ["track 12"],
                      year: "2020")
        ]
    }

    static let validUrl = URL(string: "http://localhost:8080")!

    static let validResponse = HTTPURLResponse(url: Fixtures.validUrl,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)

    static let invalidResponse = URLResponse(url: Fixtures.validUrl,
                                             mimeType: nil,
                                             expectedContentLength: 0,
                                             textEncodingName: nil)

    static let networkError = NSError(domain: "NSURLErrorDomain",
                                      code: -1004, //kCFURLErrorCannotConnectToHost
                                      userInfo: nil)
}
