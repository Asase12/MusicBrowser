//
//  MusicListService.swift
//  Music Browser
//
//  Created by Angelina on 01.05.22.
//

import Foundation
import Combine

enum APIError: LocalizedError {
    case invalidRequestError(String)
    case defaultError(String)
}

protocol MusicListLoadable {
    func loadMusicListItems() -> AnyPublisher<[MusicItem], Error>
}

protocol APIRequestBuilding {
    func buildRequest(from url: URL,
                      httpMethod: String,
                      headers: [String : String],
                      httpBody: Data?) -> URLRequest
}

final class MusicListService: APIRequestBuilding {

    // MARK: - Constants

    let urlString = "https://1979673067.rsc.cdn77.org/music-albums.json"

    // MARK: - Functions

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

extension MusicListService: MusicListLoadable {

    func loadMusicListItems() -> AnyPublisher<[MusicItem], Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidRequestError("URL invalid"))
                .eraseToAnyPublisher()
        }
        let urlRequest = buildRequest(from: url)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [MusicItem].self, decoder: JSONDecoder())
            .mapError { error in
                APIError.defaultError(error.localizedDescription)
            }
            .first()
            .eraseToAnyPublisher()
    }
}
