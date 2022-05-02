//
//  MusicItemInfoRow.swift
//  Music Browser
//
//  Created by Angelina on 01.05.22.
//

import SwiftUI
import Combine
import UIKit

struct MusicItemInfoRow: View {

    private(set) var presentation: MusicListItemPresentation

    var body: some View {
        HStack(alignment: .center, spacing: 16.0) {
            AsyncImage(url: presentation.imageUrl, placeholder: Image(systemName: "peacesign"))
                .frame(width: 40.0, height: 40.0)
                .cornerRadius(4)

            VStack(alignment: .leading, spacing: 8.0) {
                Text(presentation.title)
                    .fontWeight(.bold)
                
                Text(presentation.artist)
                    .foregroundColor(Color(.darkGray))
            }
            Spacer()
        }
    }
}

struct MusicItemRow_Previews: PreviewProvider {

    static var previews: some View {
        let presentation = MusicListItemPresentation(id: "0",
                                                     imageUrl: nil,
                                                     title: "Album's Name",
                                                     artist: "Artist")
        ZStack {
            Color.gray
            MusicItemInfoRow(presentation: presentation)
                .background(Color.white)
                .frame(width: UIScreen.main.bounds.width,
                       height: 65.0)
        }
    }
}
