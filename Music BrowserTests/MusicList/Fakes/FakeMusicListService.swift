//
//  FakeMusicListService.swift
//  Music BrowserTests
//
//  Created by Angelina on 03.05.22.
//

import Foundation
import Combine

@testable import Music_Browser

final class FakeMusicListService: MusicListLoadable {

    var response = [MusicItem]()

    func loadMusicListItems(with urlString: String) -> AnyPublisher<[MusicItem], Error> {
        Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
