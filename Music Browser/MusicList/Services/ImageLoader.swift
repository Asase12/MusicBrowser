//
//  ImageLoader.swift
//  Music Browser
//
//  Created by Angelina on 01.05.22.
//

import SwiftUI
import Combine
import Foundation

final class ImageLoader: ObservableObject {

    // MARK: - Properties

    private var cancellable: AnyCancellable?

    private(set) var url: URL?
    private(set) var placeholder: Image

    @Published var image: Image

    // MARK: - Constructor

    init(with url: URL?, using placeholder: Image) {
        self.url = url
        self.placeholder = placeholder
        self.image = placeholder
    }

    // MARK: - Functions

    func load() {
        guard let url = url else { return }
        cancellable = URLSession.shared
            .dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .subscribe(on: DispatchQueue.global())
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.updateImage(with: $0)
            }
    }

    func cancel() {
        cancellable?.cancel()
    }

    deinit {
        cancel()
    }

    private func updateImage(with uiImage: UIImage?) {
        guard let uiImage = uiImage else {
            return
        }
        image = Image(uiImage: uiImage)
    }
}

