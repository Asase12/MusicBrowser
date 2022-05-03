//
//  MusicItemsAdapter.swift
//  Music Browser
//
//  Created by Angelina on 03.05.22.
//

import Foundation

protocol MusicItemsAdapter {
    func convertToMusicListItemPresentation(from musicItems: [MusicItem]) -> [MusicListItemPresentation]
}

extension MusicItemsAdapter {

    func convertToMusicListItemPresentation(from musicItems: [MusicItem]) -> [MusicListItemPresentation] {
        musicItems
            .sorted { $0.album < $1.album }
            .compactMap {
            MusicListItemPresentation(id: $0.id,
                                      imageUrl: URL(string: $0.coverUrlString),
                                      album: $0.album,
                                      artist: $0.artist,
                                      year: $0.year)
        }
    }
}
