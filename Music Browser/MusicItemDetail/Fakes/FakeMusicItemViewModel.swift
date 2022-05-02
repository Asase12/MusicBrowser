//
//  FakeMusicItemViewModel.swift
//  Music Browser
//
//  Created by Angelina on 02.05.22.
//

import SwiftUI
import Combine

final class FakeMusicItemViewModel: ObservableObject, MusicItemViewModifier {

    var presentation = MusicDetailItemPresentation(imageUrl: nil,
                                                   artistName: "Some Artist Name",
                                                   album: "RAMMSTEIN",
                                                   label: "Parlophone UK",
                                                   year: "2002",
                                                   tracks: ["Be Quick Or Be Dead", "DEUTSCHLAND", "RADIO", "ZEIG DICH"])
}
