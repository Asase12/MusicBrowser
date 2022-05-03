//
//  MusicItem.swift
//  Music Browser
//
//  Created by Angelina on 01.05.22.
//

import Foundation

struct MusicItem: Codable {
    let id: String
    let album: String
    let artist: String
    let label: String
    let coverUrlString: String
    let tracks: [String]
    let year: String

    enum CodingKeys: String, CodingKey {
        case id
        case album
        case artist
        case label
        case coverUrlString = "cover"
        case tracks
        case year
    }
}
