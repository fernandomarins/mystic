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
            VStack(spacing: 0) {
                // Hero Image Section
                ZStack(alignment: .bottom) {
                    if card.major {
                        Image("major_\(card.id)")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 400)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, Color.black]),
                                    startPoint: .center,
                                    endPoint: .bottom
                                )
                            )
                    } else {
                        // Fallback for Minor Arcana
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 300)
                    }
                    
                    // Title Overlay
                    Text(card.name)
                        .font(.system(size: 40, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 4, x: 0, y: 2)
                        .padding(.bottom, 40) // Push up slightly to sit above the fade
                }
                
                // Content Section
                VStack(alignment: .leading, spacing: 24) {
                    SectionView(title: "Descrição", content: card.description, icon: "book.fill")
                    SectionView(title: "No trabalho", content: card.work, icon: "briefcase.fill")
                    SectionView(title: "Financeiro", content: card.financial, icon: "dollarsign.circle.fill")
                    SectionView(title: "Amor", content: card.love, icon: "heart.fill")
                    
                    if let freePerson = card.freePerson {
                        SectionView(title: "Pessoas livres", content: freePerson, icon: "person.fill")
                    }
                    if let takenPerson = card.takenPerson {
                        SectionView(title: "Pessoas compromissadas", content: takenPerson, icon: "person.2.fill")
                    }
                    
                    SectionView(title: "Obstáculo", content: card.obstacle, icon: "exclamationmark.triangle.fill")
                    SectionView(title: "Conselho", content: card.advice, icon: "star.fill")
                }
                .padding()
                .background(Color.black.opacity(0.8)) // Dark background for content
            }
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.black)
    }
}

private struct SectionView: View {
    let title: String
    let content: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.purple)
                Text(title)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(.gray)
                .lineSpacing(4)
            
            Divider()
                .background(Color.gray.opacity(0.3))
        }
    }
}



#Preview {
    CardView(card: .init(id: 0, major: true, suit: nil, name: "O Mago", description: "Ousadia", work: "Ousadia", financial: "Ousadia", love: "Ousadia", obstacle: "Ousadia", advice: "Ousadia", freePerson: "Ousadia", takenPerson: "Ousadia"))
}
