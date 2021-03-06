//
//  MusicListItemPresentation.swift
//  Music Browser
//
//  Created by Angelina on 01.05.22.
//

import Foundation

struct MusicListItemPresentation: Identifiable {
    let id: String
    let imageUrl: URL?
    let album: String
    let artist: String
    let year: String
}
