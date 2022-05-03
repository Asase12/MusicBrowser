//
//  FakeMusicListViewModel.swift
//  Music Browser
//
//  Created by Angelina on 01.05.22.
//

import Foundation
import SwiftUI

final class FakeMusicListViewModel: ObservableObject, MusicItemsModifier {

    var presentationItems = [
        MusicListItemPresentation(id: "0", imageUrl: nil, album: "Song Title", artist: "Artist Name", year: "2007")
    ]

    var isLoading = true
    var isFilterActive = false
    var filteredItems = [MusicListItemPresentation]()

    func updateMusicItems(completion: ([MusicItem]) -> Void) {}
    
    func musicDetailItemViewModel(for musicItemId: String, with imageUrl: URL?) -> MusicDetailItemViewModel? {
        return nil
    }

    func filter(with searchText: String) {}
}
