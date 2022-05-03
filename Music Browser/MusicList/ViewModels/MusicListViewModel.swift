//
//  MusicListViewModel.swift
//  Music Browser
//
//  Created by Angelina on 01.05.22.
//

import Foundation
import Combine
import SwiftUI

typealias MusicItemsModifier = MusicItemsPresenting & MusicItemsFetching & Loading & MusicDetailItemViewModelBuilding & MusicItemsFiltering

protocol MusicItemsPresenting: AnyObject {
    var presentationItems: [MusicListItemPresentation] { get }
}

protocol MusicItemsFetching: AnyObject {
    func updateMusicItems(completion: @escaping ([MusicItem]) -> Void)
}

protocol Loading: AnyObject {
    var isLoading: Bool { get }
}

protocol MusicDetailItemViewModelBuilding: AnyObject {
    func musicDetailItemViewModel(for musicItemId: String, with imageUrl: URL?) -> MusicDetailItemViewModel?
}

protocol MusicItemsFiltering: AnyObject {
    var isFilterActive: Bool { get }
    var filteredItems: [MusicListItemPresentation] { get }

    func filter(with searchText: String)
}

final class MusicListViewModel: ObservableObject, Loading, MusicItemsPresenting, MusicItemsAdapter {

    // MARK: - Properties

    private var disposables: Set<AnyCancellable>
    private(set) var service: MusicListLoadable

    @Published private(set) var presentationItems = [MusicListItemPresentation]()
    @Published private(set) var isLoading = false
    @Published private(set) var isFilterActive = false
    @Published private(set) var filteredItems = [MusicListItemPresentation]()

    @Published var musicItems = [MusicItem]()

    // MARK: - Constructor

    init(with service: MusicListLoadable) {
        self.service = service
        self.disposables = Set<AnyCancellable>()
        subscribeForUpdates()
    }

    // MARK: - Private functions

    private func subscribeForUpdates() {
        $musicItems
            .dropFirst()
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.presentationItems = self.convertToMusicListItemPresentation(from: newValue)
        }
        .store(in: &disposables)
    }
}

extension MusicListViewModel: MusicItemsFetching {

    func updateMusicItems(completion: @escaping ([MusicItem]) -> Void) {
        isLoading = true
        service.loadMusicListItems(with: APIEndPoints.musicItemsList)
            .retry(3)
            .subscribe(on: DispatchQueue.global())
            .receive(on: RunLoop.main)
            .sink { _ in
            } receiveValue: { [weak self] items in
                self?.musicItems = items
                self?.isLoading = false
                completion(items)
            }
            .store(in: &disposables)
    }
}

extension MusicListViewModel: MusicDetailItemViewModelBuilding {

    func musicDetailItemViewModel(for musicItemId: String, with imageUrl: URL?) -> MusicDetailItemViewModel? {
        guard let musicItem = musicItems.first(where: { $0.id == musicItemId }) else {
            return nil
        }
        let presentation = MusicDetailItemPresentation(imageUrl: imageUrl,
                                                       artistName: musicItem.artist,
                                                       album: musicItem.album,
                                                       label: musicItem.label,
                                                       year: musicItem.year,
                                                       tracks: musicItem.tracks)
        return MusicDetailItemViewModel(with: presentation)
    }
}

extension MusicListViewModel: MusicItemsFiltering {

    func filter(with searchText: String) {
        isFilterActive = !searchText.preparedSearchString.isEmpty
        guard isFilterActive else {
            filteredItems.removeAll()
            return
        }
        let preparedSearch = searchText.lowercased()
        let filteredMusicItems = musicItems.filter {(musicItem: MusicItem) -> Bool in
            return musicItem.album.lowercased().contains(preparedSearch) ||
                musicItem.artist.lowercased().contains(preparedSearch) ||
                musicItem.label.lowercased().contains(preparedSearch) ||
                musicItem.year.lowercased().contains(preparedSearch) ||
                musicItem.tracks.filter({ (track: String) -> Bool in
                    return track.lowercased().contains(preparedSearch)
                }).count > 0
        }.sorted { $0.album < $1.album }
        filteredItems = convertToMusicListItemPresentation(from: filteredMusicItems)
    }
}
