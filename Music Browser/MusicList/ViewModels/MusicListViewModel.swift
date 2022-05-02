//
//  MusicListViewModel.swift
//  Music Browser
//
//  Created by Angelina on 01.05.22.
//

import Foundation
import Combine
import SwiftUI

protocol MusicItemsModifier: AnyObject {
    var presentationItems: [MusicListItemPresentation] { get }
    var isLoading: Bool { get }

    func updateMusicItems()
}

protocol MusicDetailItemViewModelBuilding: AnyObject {
    func musicDetailItemViewModel(for musicItemId: String, with imageUrl: URL?) -> MusicDetailItemViewModel?
}

final class MusicListViewModel: ObservableObject {

    // MARK: - Properties

    private var disposables: Set<AnyCancellable>

    private(set) var service: MusicListLoadable

    @Published private(set) var musicItems: [MusicItem] = []
    @Published private(set) var presentationItems: [MusicListItemPresentation] = []
    @Published private(set) var isLoading = false

    // MARK: - Constructor

    init(with service: MusicListLoadable) {
        self.service = service
        self.disposables = Set<AnyCancellable>()
        subscribeForUpdates()
    }

    // MARK: - Functions

    // MARK: - Private functions

    private func subscribeForUpdates() {
        $musicItems
            .dropFirst()
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.presentationItems = self.convertToMusicListItemPresentation(from: newValue)
                self.isLoading = false
        }
        .store(in: &disposables)
    }

    //TODO: move to a protocol, test it
    private func convertToMusicListItemPresentation(from musicItems: [MusicItem]) -> [MusicListItemPresentation] {
        musicItems.compactMap {
            MusicListItemPresentation(id: $0.id,
                                      imageUrl: URL(string: $0.coverUrlString),   // TODO: caching of the image?
                                      title: $0.label,
                                      artist: $0.artist)
        }
    }
}

extension MusicListViewModel: MusicItemsModifier {

    func updateMusicItems() {
        isLoading = true
        service.loadMusicListItems()
            .retry(3)
            .subscribe(on: DispatchQueue.global())
            .receive(on: RunLoop.main)
            .sink { _ in
            } receiveValue: { [weak self] musicItems in
                self?.musicItems = musicItems
            }
            .store(in: &disposables)
    }
}

extension MusicListViewModel: MusicDetailItemViewModelBuilding {

    func musicDetailItemViewModel(for musicItemId: String, with imageUrl: URL?) -> MusicDetailItemViewModel? {
        guard let musicItem = musicItems.first(where: { $0.id == musicItemId }) else {
            return nil
        }
        print("MusicListViewModel: \(#function): musicItem = \(musicItem)")
        let presentation = MusicDetailItemPresentation(imageUrl: imageUrl,
                                                       artistName: musicItem.artist,
                                                       album: musicItem.album,
                                                       label: musicItem.label,
                                                       year: musicItem.year,
                                                       tracks: musicItem.tracks)
        return MusicDetailItemViewModel(with: presentation)
    }
}
