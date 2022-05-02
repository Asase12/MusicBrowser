//
//  MusicDetailItemViewModel.swift
//  Music Browser
//
//  Created by Angelina on 02.05.22.
//

import Foundation
import Combine

protocol MusicItemViewModifier: AnyObject {
    var presentation: MusicDetailItemPresentation { get }
}

final class MusicDetailItemViewModel: ObservableObject, MusicItemViewModifier {

    @Published private(set) var presentation: MusicDetailItemPresentation

    init(with presentation: MusicDetailItemPresentation) {
        self.presentation = presentation
    }
}
