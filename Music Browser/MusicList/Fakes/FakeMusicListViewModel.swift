//
//  FakeMusicListViewModel.swift
//  Music Browser
//
//  Created by Angelina on 01.05.22.
//

import Foundation
import SwiftUI

final class FakeMusicListViewModel: ObservableObject, MusicItemsModifier, MusicDetailItemViewModelBuilding {

    var presentationItems = [
        MusicListItemPresentation(id: "0", imageUrl: nil, title: "Song Title", artist: "Artist Name", year: "2007")
    ]

    var isLoading = true

    func updateMusicItems() {}
    
    func musicDetailItemViewModel(for musicItemId: String, with imageUrl: URL?) -> MusicDetailItemViewModel? {
        return nil
    }
}
