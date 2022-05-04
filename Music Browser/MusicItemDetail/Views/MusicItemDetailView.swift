//
//  MusicItemDetailView.swift
//  Music Browser
//
//  Created by Angelina on 02.05.22.
//

import SwiftUI
import Combine

struct MusicItemDetailView<ViewModel>: View where ViewModel: ObservableObject & MusicItemViewModifier {

    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .center) {

                    AlbumDetailView(album: viewModel.presentation.album,
                                  label: viewModel.presentation.label,
                                  year: viewModel.presentation.year)

                    VStack(alignment: .leading, spacing: 16.0) {
                        Text("Tracks:")
                            .fontWeight(.bold)

                        ForEach(viewModel.presentation.tracks, id: \.self) { track in
                            HStack(spacing: 12.0) {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 8, height: 8)
                                Text(track)
                                Spacer()
                            }
                        }
                    }
                    .padding(.bottom, 24)

                    Spacer()
                }
                .padding(.leading, 24)
                .padding(.trailing, 24)
                .navigationBarTitle(viewModel.presentation.artistName, displayMode: .inline)
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct AlbumDetailView: View {

    private(set) var imageUrl: URL?
    private(set) var album: String
    private(set) var label: String
    private(set) var year: String

    var body: some View {
        AsyncImage(url: imageUrl, placeholder: Image(systemName: "peacesign"))
            .frame(width: 180, height: 180)
            .cornerRadius(8)
            .padding(.top, 20)
            .padding(.bottom, 20)

        Text(album)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(.bottom, 20)

        Text(label)
            .foregroundColor(Color(.darkGray))
            .padding(.bottom, 2.0)

        Text(year)
            .foregroundColor(Color(.darkGray))
            .padding(.bottom, 20)
    }
}

struct MusicItemDetailView_Previews: PreviewProvider {

    static var previews: some View {
        let viewModel = FakeMusicItemViewModel()
        MusicItemDetailView(viewModel: viewModel)
    }
}
