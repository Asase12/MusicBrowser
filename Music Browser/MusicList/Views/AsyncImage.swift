//
//  AsyncImage.swift
//  Music Browser
//
//  Created by Angelina on 01.05.22.
//

import SwiftUI

struct AsyncImage: View {

    @StateObject private var loader: ImageLoader
    
    private(set) var placeholder: Image
    private(set) var contentMode: ContentMode

    init(url: URL?, placeholder: Image, contentMode: ContentMode = .fit) {
        self.placeholder = placeholder
        self.contentMode = contentMode
        _loader = StateObject(wrappedValue: ImageLoader(with: url, using: placeholder))
    }

    var body: some View {
        loader.image
            .resizable()
            .aspectRatio(contentMode: contentMode)

        .onAppear(perform: loader.load)
    }
}
