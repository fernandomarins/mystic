//
//  ContentView.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct CardListView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    LoadingIndicator(
                        animation: .circleBars,
                        color: .white,
                        size: .large
                    )
                } else {
                    List {
                        createSection(title: "Arcanos Maiores", cards: viewModel.cards.filter { $0.major })
                        createSuitSection(suit: .clubs, title: "Paus ♣️")
                        createSuitSection(suit: .hearts, title: "Copas ❤️")
                        createSuitSection(suit: .diamonds, title: "Ouros ♦️")
                        createSuitSection(suit: .spades, title: "Espadas ♠️")
                    }
                    .scrollIndicators(.hidden)
                    .navigationTitle("Arcanos")
                    .refreshable {
                        Task {
                            await viewModel.fetchCards()
                        }
                    }
                }
            }
            .onAppear {
                if viewModel.cards.isEmpty {
                    Task {
                        await viewModel.fetchCards()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func createSection(title: String, cards: [CardModel]) -> some View {
        Section(header: Text(title)) {
            ForEach(cards) { card in
                NavigationLink(destination: CardView(card: card)) {
                    Text(card.name)
                }
            }
        }
    }

    @ViewBuilder
    private func createSuitSection(suit: CardSuit, title: String) -> some View {
        createSection(title: title, cards: viewModel.cards.filter { $0.suit == suit })
    }
}

#Preview {
    CardListView()
}
