//
//  AlphabetListView.swift
//  tarot
//
//  Created by Fernando Marins on 22/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct AlphabetListView: View {
    @StateObject private var viewModel = ViewModel(service: Service())
    @State private var searchQuery: String = ""
    
    private var filteredLetters: [LetterModel] {
        if searchQuery.isEmpty {
            return viewModel.alphabet
        } else {
            return viewModel.alphabet.filter { letter in
                letter.pronunciation.lowercased().contains(searchQuery.lowercased())
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
                        size: .large
                    )
                } else {
                    ScrollView {
                        runeCollectionView
                            .padding(.top, 16)
                    }
                    .navigationTitle("Alfabeto")
                    .refreshable {
                        await viewModel.fetchRunes()
                    }
                    .searchable(text: $searchQuery, prompt: "Letra")
                    .textInputAutocapitalization(.never)
                    .scrollIndicators(.hidden)
                }
            }
            .onAppear {
                if viewModel.alphabet.isEmpty {
                    Task {
                        await viewModel.fetchAlphabet()
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
            ForEach(filteredLetters, id: \.self) { letter in
                NavigationLink(destination: LetterView(letter: letter)) {
                    Text(letter.letter)
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    AlphabetListView()
}
