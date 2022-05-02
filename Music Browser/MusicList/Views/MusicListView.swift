//
//  MusicListView.swift
//  Music Browser
//
//  Created by Angelina on 01.05.22.
//

import SwiftUI

struct MusicListView<ViewModel>: View where ViewModel: MusicItemsModifier & ObservableObject {

    @State private(set) var searchQuery = ""
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {

                List(viewModel.isFilterActive ? viewModel.filteredItems : viewModel.presentationItems) { presentationItem in

                    if let detailViewModel = viewModel.musicDetailItemViewModel(for: presentationItem.id,
                                                                                with: presentationItem.imageUrl) {
                        NavigationLink(destination: MusicItemDetailView(viewModel: detailViewModel)) {
                            MusicItemInfoRow(presentation: presentationItem)
                        }
                    } else {
                        MusicItemInfoRow(presentation: presentationItem)
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.bottom, 20.0)
                .padding(.trailing, 20.0)

                ProgressView().isRemoved(!viewModel.isLoading)
            }
            .navigationBarTitle(Text("Music Browser"), displayMode: .inline)
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .automatic))
            .onChange(of: searchQuery) { text in
                viewModel.filter(with: text)
            }
            .gesture(DragGesture().onChanged({ _ in
                UIApplication.shared.endEditing()
            }))
        }
        .onAppear() {
            viewModel.updateMusicItems()
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        let viewModel = FakeMusicListViewModel()
        MusicListView(viewModel: viewModel)
    }
}
