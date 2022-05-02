//
//  Music_BrowserApp.swift
//  Music Browser
//
//  Created by Angelina on 01.05.22.
//

import SwiftUI

@main
struct Music_BrowserApp: App {
    
    var body: some Scene {
        WindowGroup {
            let service = MusicListService()
            let viewModel = MusicListViewModel(with: service)
            MusicListView(viewModel: viewModel)
        }
    }
}
