//
//  ContentView.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct CardListView: View {
    @StateObject private var viewModel = CardViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            if viewModel.isLoading {
                LoadingIndicator(
                    animation: .circleBars,
                    color: .white,
                    size: .large
                )
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Selecione um grupo")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.leading, 4)
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            // Major Arcana Selector
                            CardGroupCell(
                                title: "Arcanos Maiores",
                                icon: "🌟",
                                cards: viewModel.cards.filter { $0.major }
                            )
                            
                            // Minor Arcana Selectors
                            CardGroupCell(
                                title: "Paus",
                                icon: "♣️",
                                cards: viewModel.cards.filter { $0.suit == .clubs }
                            )
                            CardGroupCell(
                                title: "Copas",
                                icon: "❤️",
                                cards: viewModel.cards.filter { $0.suit == .hearts }
                            )
                            CardGroupCell(
                                title: "Ouros",
                                icon: "♦️",
                                cards: viewModel.cards.filter { $0.suit == .diamonds }
                            )
                            CardGroupCell(
                                title: "Espadas",
                                icon: "♠️",
                                cards: viewModel.cards.filter { $0.suit == .spades }
                            )
                        }
                    }
                    .padding()
                }
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
        .backButtonStyle()
    }
}

struct CardGroupCell: View {
    let title: String
    let icon: String
    let cards: [CardModel]
    
    var body: some View {
        NavigationLink(destination: SuitListView(title: "\(title) \(icon)", cards: cards)) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "1A1A1A"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                
                VStack(spacing: 8) {
                    Text(icon)
                        .font(.system(size: 40))
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .frame(height: 140)
        }
    }
}

#Preview {
    CardListView()
}
