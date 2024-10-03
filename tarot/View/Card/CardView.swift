//
//  CardView.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import SwiftUI

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme

    let card: CardModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Text(card.name)
                .font(.title)
                .bold()
            DividerView()
            
            VStack(alignment: .leading, spacing: 20) {
                SectionView(title: "Descrição", content: card.description)
                SectionView(title: "No trabalho", content: card.work)
                SectionView(title: "Financeiro", content: card.financial)
                SectionView(title: "Amor", content: card.love)
                
                if let freePerson = card.freePerson {
                    SectionView(title: "Pessoas livres", content: freePerson)
                }
                if let takenPerson = card.takenPerson {
                    SectionView(title: "Pessoas compromissadas", content: takenPerson)
                }
                
                SectionView(title: "Obstáculo", content: card.obstacle)
                SectionView(title: "Conselho", content: card.advice)
            }
        }
        .padding()
    }
}

private struct SectionView: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .bold()
            Text(content)
            DividerView()
        }
    }
}

private struct DividerView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Rectangle()
            .fill(colorScheme == .dark ? Color.white : Color.black)
            .frame(height: 2)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    CardView(card: .init(id: 0, major: true, suit: nil, name: "O Mago", description: "Ousadia", work: "Ousadia", financial: "Ousadia", love: "Ousadia", obstacle: "Ousadia", advice: "Ousadia", freePerson: "Ousadia", takenPerson: "Ousadia"))
}
