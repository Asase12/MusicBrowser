//
//  MusicListServiceTests.swift
//  Music BrowserTests
//
//  Created by Angelina on 03.05.22.
//

import XCTest
import Combine

@testable import Music_Browser

class MusicListServiceTests: XCTestCase {

    var disposables = Set<AnyCancellable>()
    
    var customPublisher: APISessionDataPublisher!

    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]

        let session = URLSession(configuration: config)
        customPublisher = APISessionDataPublisher(session: session)
    }

    override func tearDownWithError() throws {
        URLProtocolMock.response = nil
        URLProtocolMock.error = nil
        URLProtocolMock.testURLs = [URL?: Data]()
    }

    func testLoadMusicListItems_when_valid_response() throws {
        let service = MusicListService(with: customPublisher)
        let data = try JSONEncoder().encode(Fixtures.fakeItems)
        URLProtocolMock.testURLs = [Fixtures.validUrl: data]
        URLProtocolMock.response = Fixtures.validResponse
        let expectation = expectation(description: "Load MusicList Items when response is valid")

        var musicItems = [MusicItem]()
        var apiError: Error?
        service.loadMusicListItems(with: Fixtures.validUrl.absoluteString)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    apiError = error
                }
                expectation.fulfill()
            } receiveValue: { items in
                musicItems = items
            }
            .store(in: &disposables)

        wait(for: [expectation], timeout: 5)

        XCTAssertEqual(musicItems.count, 3)

        XCTAssertEqual(musicItems[0].id, "10")
        XCTAssertEqual(musicItems[0].album, "album 0")
        XCTAssertEqual(musicItems[0].artist, "artist 0")
        XCTAssertEqual(musicItems[0].label, "label 0")
        XCTAssertEqual(musicItems[0].coverUrlString, "url 0")
        XCTAssertEqual(musicItems[0].tracks.count, 1)
        XCTAssertEqual(musicItems[0].tracks[0], "track 00")
        XCTAssertEqual(musicItems[0].year, "1990")

        XCTAssertEqual(musicItems[1].id, "11")
        XCTAssertEqual(musicItems[1].album, "some album 1")
        XCTAssertEqual(musicItems[1].artist, "artist 1")
        XCTAssertEqual(musicItems[1].label, "label 1")
        XCTAssertEqual(musicItems[1].coverUrlString, "url 1")
        XCTAssertEqual(musicItems[1].tracks.count, 2)
        XCTAssertEqual(musicItems[1].tracks[0], "track 01")
        XCTAssertEqual(musicItems[1].tracks[1], "some track")
        XCTAssertEqual(musicItems[1].year, "2001")

        XCTAssertEqual(musicItems[2].id, "12")
        XCTAssertEqual(musicItems[2].album, "last album 2")
        XCTAssertEqual(musicItems[2].artist, "artist 2")
        XCTAssertEqual(musicItems[2].label, "label 2")
        XCTAssertEqual(musicItems[2].coverUrlString, "url 2")
        XCTAssertEqual(musicItems[2].tracks.count, 1)
        XCTAssertEqual(musicItems[2].tracks[0], "track 12")
        XCTAssertEqual(musicItems[2].year, "2020")

        XCTAssertNil(apiError)
    }

    func testLoadMusicListItems_when_invalid_response() throws {
        let service = MusicListService(with: customPublisher)
        URLProtocolMock.response = Fixtures.invalidResponse
        let expectation = expectation(description: "Load MusicList Items when response is invalid")

        var musicItems = [MusicItem]()
        var apiError: Error?
        service.loadMusicListItems(with: Fixtures.validUrl.absoluteString)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    apiError = error
                }
                expectation.fulfill()
            } receiveValue: { items in
                musicItems = items
            }
            .store(in: &disposables)

        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(musicItems.count, 0)
        XCTAssertNotNil(apiError)
    }

    func testLoadMusicListItems_when_invalid_url() throws {
        let service = MusicListService(with: customPublisher)
        URLProtocolMock.response = Fixtures.validResponse
        let expectation = expectation(description: "Load MusicList Items when response is invalid")

        var musicItems = [MusicItem]()
        var apiError: APIError?
        service.loadMusicListItems(with: "example")
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    apiError = error as? APIError
                }
                expectation.fulfill()
            } receiveValue: { items in
                musicItems = items
            }
            .store(in: &disposables)

        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(musicItems.count, 0)
        XCTAssertEqual(apiError, .invalidRequestError("URL invalid"))
    }

    func testLoadMusicListItems_when_error_occurred() throws {
        let service = MusicListService(with: customPublisher)
        URLProtocolMock.response = Fixtures.invalidResponse
        URLProtocolMock.error = Fixtures.networkError
        let expectation = expectation(description: "Load MusicList Items when response is invalid")

        var musicItems = [MusicItem]()
        var apiError: APIError?
        service.loadMusicListItems(with: Fixtures.validUrl.absoluteString)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    apiError = error as? APIError
                }
                expectation.fulfill()
            } receiveValue: { items in
                musicItems = items
            }
            .store(in: &disposables)

        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(musicItems.count, 0)
        XCTAssertEqual(apiError, .defaultError)
    }
}

