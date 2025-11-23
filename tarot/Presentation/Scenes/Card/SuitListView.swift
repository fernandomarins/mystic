//
//  SuitListView.swift
//  tarot
//
//  Created by Fernando Marins on 22/11/24.
//

import SwiftUI

struct SuitListView: View {
    let title: String
    let cards: [CardModel]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(cards) { card in
                        NavigationLink(destination: CardView(card: card)) {
                            TarotCardCell(card: card)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        SuitListView(title: "Espadas ♠️", cards: [])
    }
}
