//
//  RuneListView.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct RuneListView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var searchQuery: String = ""
    
    private var filteredRunes: [RuneModel] {
        if searchQuery.isEmpty {
            return viewModel.runes
        } else {
            return viewModel.runes.filter { rune in
                rune.name.lowercased().contains(searchQuery.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    LoadingIndicator(
                        animation: .circleBars,
                        color: .white,
                        size: .medium
                    )
                } else {
                    ScrollView {
                        runeCollectionView
                            .padding(.top, 16)
                    }
                    .navigationTitle("Runas")
                    .refreshable {
                        await viewModel.fetchRunes()
                    }
                    .searchable(text: $searchQuery, prompt: "Runa")
                    .textInputAutocapitalization(.never)
                    .scrollIndicators(.hidden)
                }
            }
            .onAppear {
                if viewModel.runes.isEmpty {
                    Task {
                        await viewModel.fetchRunes()
                    }
                }
            }
        }
    }
    
    private var runeCollectionView: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 16
        ) {
            ForEach(filteredRunes) { rune in
                NavigationLink(destination: RuneView(rune: rune)) {
                    VStack {
                        Text(rune.name)
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        runeImage(for: rune)
                            .frame(width: 75, height: 125)
                            .scaledToFit()
                    }
                    .frame(width: 150, height: 180)
                }
            }
        }
    }
    
    private func runeImage(for rune: RuneModel) -> some View {
        Image(uiImage: UIImage(named: rune.name) ?? UIImage())
            .resizable()
    }
}

#Preview {
    RuneListView()
}
