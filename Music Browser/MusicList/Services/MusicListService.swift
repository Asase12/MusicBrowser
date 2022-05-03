//
//  MusicListService.swift
//  Music Browser
//
//  Created by Angelina on 01.05.22.
//

import Foundation
import Combine
import UIKit

enum APIError: LocalizedError, Equatable {
    case invalidRequestError(String)
    case defaultError(String)
}

struct APIEndPoints {
    static let musicItemsList = "https://1979673067.rsc.cdn77.org/music-albums.json"
}

protocol MusicListLoadable {
    func loadMusicListItems(with urlString: String) -> AnyPublisher<[MusicItem], Error>
}

final class MusicListService: APIRequestBuilding, MusicListLoadable {

    var publisher: APIDataTaskPublisher

    init(with publisher: APIDataTaskPublisher = APISessionDataPublisher()) {
        self.publisher = publisher
    }

    func loadMusicListItems(with urlString: String) -> AnyPublisher<[MusicItem], Error> {
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else {
            return Fail(error: APIError.invalidRequestError("URL invalid"))
                .eraseToAnyPublisher()
        }
        let urlRequest = buildRequest(from: url)
        return publisher.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: [MusicItem].self, decoder: JSONDecoder())
            .mapError { error in
                APIError.defaultError(error.localizedDescription)
            }
            .first()
            .eraseToAnyPublisher()
    }
}
