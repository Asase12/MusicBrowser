//
//  MusicListViewModelTests.swift
//  Music BrowserTests
//
//  Created by Angelina on 03.05.22.
//

import XCTest
import Combine

@testable import Music_Browser

class MusicListViewModelTests: XCTestCase {

    var disposables = Set<AnyCancellable>()

    var viewModel: MusicListViewModel!
    var service: FakeMusicListService!

    override func setUpWithError() throws {
        service = FakeMusicListService()
        viewModel = MusicListViewModel(with: service)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        service = nil
    }

    func test_viewModel_when_created() {
        XCTAssertTrue(viewModel.musicItems.isEmpty)
        XCTAssertTrue(viewModel.presentationItems.isEmpty)
        XCTAssertTrue(viewModel.filteredItems.isEmpty)

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isFilterActive)
    }

    func test_isLoading_when_updateMusicItems_is_called() {
        viewModel.updateMusicItems { _ in }

        XCTAssertTrue(viewModel.isLoading)
    }

    func test_updateMusicItems() {
        let expectation = expectation(description: "updateMusicItems should return correct musicItems array")
        service.response = Fixtures.fakeItems

        viewModel.updateMusicItems { items in
            XCTAssertEqual(self.viewModel.musicItems.count, 3)
            
            XCTAssertEqual(self.viewModel.musicItems[0].id, "10")
            XCTAssertEqual(self.viewModel.musicItems[0].album, "album 0")
            XCTAssertEqual(self.viewModel.musicItems[0].artist, "artist 0")
            XCTAssertEqual(self.viewModel.musicItems[0].label, "label 0")
            XCTAssertEqual(self.viewModel.musicItems[0].coverUrlString, "url 0")
            XCTAssertEqual(self.viewModel.musicItems[0].tracks.count, 1)
            XCTAssertEqual(self.viewModel.musicItems[0].tracks[0], "track 00")
            XCTAssertEqual(self.viewModel.musicItems[0].year, "1990")

            XCTAssertEqual(self.viewModel.musicItems[1].id, "11")
            XCTAssertEqual(self.viewModel.musicItems[1].album, "some album 1")
            XCTAssertEqual(self.viewModel.musicItems[1].artist, "artist 1")
            XCTAssertEqual(self.viewModel.musicItems[1].label, "label 1")
            XCTAssertEqual(self.viewModel.musicItems[1].coverUrlString, "url 1")
            XCTAssertEqual(self.viewModel.musicItems[1].tracks.count, 2)
            XCTAssertEqual(self.viewModel.musicItems[1].tracks[0], "track 01")
            XCTAssertEqual(self.viewModel.musicItems[1].tracks[1], "some track")
            XCTAssertEqual(self.viewModel.musicItems[1].year, "2001")

            XCTAssertEqual(self.viewModel.musicItems[2].id, "12")
            XCTAssertEqual(self.viewModel.musicItems[2].album, "last album 2")
            XCTAssertEqual(self.viewModel.musicItems[2].artist, "artist 2")
            XCTAssertEqual(self.viewModel.musicItems[2].label, "label 2")
            XCTAssertEqual(self.viewModel.musicItems[2].coverUrlString, "url 2")
            XCTAssertEqual(self.viewModel.musicItems[2].tracks.count, 1)
            XCTAssertEqual(self.viewModel.musicItems[2].tracks[0], "track 12")
            XCTAssertEqual(self.viewModel.musicItems[2].year, "2020")

            XCTAssertFalse(self.viewModel.isLoading)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func test_musicItems_update() {
        viewModel.musicItems = Fixtures.fakeItems

        viewModel.$musicItems.sink { _ in
            XCTAssertEqual(self.viewModel.presentationItems.count, 3)

            XCTAssertEqual(self.viewModel.presentationItems[0].id, "10")
            XCTAssertEqual(self.viewModel.presentationItems[0].album, "album 0")
            XCTAssertEqual(self.viewModel.presentationItems[0].artist, "artist 0")
            XCTAssertEqual(self.viewModel.presentationItems[0].year, "1990")

            XCTAssertEqual(self.viewModel.presentationItems[1].id, "12")
            XCTAssertEqual(self.viewModel.presentationItems[1].album, "last album 2")
            XCTAssertEqual(self.viewModel.presentationItems[1].artist, "artist 2")
            XCTAssertEqual(self.viewModel.presentationItems[1].year, "2020")

            XCTAssertEqual(self.viewModel.presentationItems[2].id, "11")
            XCTAssertEqual(self.viewModel.presentationItems[2].album, "some album 1")
            XCTAssertEqual(self.viewModel.presentationItems[2].artist, "artist 1")
            XCTAssertEqual(self.viewModel.presentationItems[2].year, "2001")
        }
        .store(in: &disposables)
    }

    func test_MusicDetailItemViewModelBuilding() {
        viewModel.musicItems = Fixtures.fakeItems

        let detailViewModel = viewModel.musicDetailItemViewModel(for: "10", with: Fixtures.validUrl)

        XCTAssertEqual(detailViewModel?.presentation.artistName, "artist 0")
        XCTAssertEqual(detailViewModel?.presentation.album, "album 0")
        XCTAssertEqual(detailViewModel?.presentation.label, "label 0")
        XCTAssertEqual(detailViewModel?.presentation.imageUrl?.absoluteString, "http://localhost:8080")
        XCTAssertEqual(detailViewModel?.presentation.year, "1990")
        XCTAssertEqual(detailViewModel?.presentation.tracks.count, 1)
        XCTAssertEqual(detailViewModel?.presentation.tracks[0], "track 00")
    }

    func test_MusicDetailItemViewModelBuilding_when_musicItemId_not_found() {
        viewModel.musicItems = []
        
        let detailViewModel = viewModel.musicDetailItemViewModel(for: "10", with: Fixtures.validUrl)

        XCTAssertNil(detailViewModel)
    }

    func test_filter_by_album() {
        viewModel.musicItems = Fixtures.fakeItems

        viewModel.filter(with: "album 0")

        XCTAssertTrue(viewModel.isFilterActive)
        XCTAssertEqual(viewModel.filteredItems.count, 1)
        XCTAssertEqual(viewModel.filteredItems[0].id, "10")
        XCTAssertEqual(viewModel.filteredItems[0].album, "album 0")
        XCTAssertEqual(viewModel.filteredItems[0].artist, "artist 0")
        XCTAssertEqual(viewModel.filteredItems[0].year, "1990")
    }

    func test_filter_by_artist() {
        viewModel.musicItems = Fixtures.fakeItems

        viewModel.filter(with: "artist 2")

        XCTAssertTrue(viewModel.isFilterActive)
        XCTAssertEqual(viewModel.filteredItems.count, 1)
        XCTAssertEqual(viewModel.filteredItems[0].id, "12")
        XCTAssertEqual(viewModel.filteredItems[0].album, "last album 2")
        XCTAssertEqual(viewModel.filteredItems[0].artist, "artist 2")
        XCTAssertEqual(viewModel.filteredItems[0].year, "2020")
    }

    func test_filter_by_label() {
        viewModel.musicItems = Fixtures.fakeItems

        viewModel.filter(with: "label 2")

        XCTAssertTrue(viewModel.isFilterActive)
        XCTAssertEqual(viewModel.filteredItems.count, 1)
        XCTAssertEqual(viewModel.filteredItems[0].id, "12")
        XCTAssertEqual(viewModel.filteredItems[0].album, "last album 2")
        XCTAssertEqual(viewModel.filteredItems[0].artist, "artist 2")
        XCTAssertEqual(viewModel.filteredItems[0].year, "2020")
    }

    func test_filter_by_track() {
        viewModel.musicItems = Fixtures.fakeItems

        viewModel.filter(with: "some")

        XCTAssertTrue(viewModel.isFilterActive)
        XCTAssertEqual(viewModel.filteredItems.count, 1)
        XCTAssertEqual(viewModel.filteredItems[0].id, "11")
        XCTAssertEqual(viewModel.filteredItems[0].album, "some album 1")
        XCTAssertEqual(viewModel.filteredItems[0].artist, "artist 1")
        XCTAssertEqual(viewModel.filteredItems[0].year, "2001")
    }

    func test_filter_by_year() {
        viewModel.musicItems = Fixtures.fakeItems

        viewModel.filter(with: "1990")

        XCTAssertTrue(viewModel.isFilterActive)
        XCTAssertEqual(viewModel.filteredItems.count, 1)
        XCTAssertEqual(viewModel.filteredItems[0].id, "10")
        XCTAssertEqual(viewModel.filteredItems[0].album, "album 0")
        XCTAssertEqual(viewModel.filteredItems[0].artist, "artist 0")
        XCTAssertEqual(viewModel.filteredItems[0].year, "1990")
    }

    func test_filter_with_empty_searchText() {
        viewModel.musicItems = Fixtures.fakeItems

        viewModel.filter(with: " ")

        XCTAssertFalse(viewModel.isFilterActive)
        XCTAssertTrue(viewModel.filteredItems.isEmpty)
    }

    func test_filter_with_invalid_searchText() {
        viewModel.musicItems = Fixtures.fakeItems

        viewModel.filter(with: "123")

        XCTAssertTrue(viewModel.isFilterActive)
        XCTAssertTrue(viewModel.filteredItems.isEmpty)
    }
}
