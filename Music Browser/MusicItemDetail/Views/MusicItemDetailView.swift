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

                    AsyncImage(url: viewModel.presentation.imageUrl, placeholder: Image(systemName: "peacesign"))
                        .frame(width: 180, height: 180)
                        .cornerRadius(8)
                        .padding(.top, 20)
                        .padding(.bottom, 20)

                    Text(viewModel.presentation.album)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)

                    Text(viewModel.presentation.label)
                        .foregroundColor(Color(.darkGray))
                        .padding(.bottom, 2.0)

                    Text(viewModel.presentation.year)
                        .foregroundColor(Color(.darkGray))
                        .padding(.bottom, 20)

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
    }
}

struct MusicItemDetailView_Previews: PreviewProvider {

    static var previews: some View {
        let viewModel = FakeMusicItemViewModel()
        MusicItemDetailView(viewModel: viewModel)
    }
}
