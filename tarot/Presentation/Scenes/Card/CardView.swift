//
//  CardView.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import SwiftUI

struct CardView: View {
    let card: CardModel
    
    var body: some View {
        ZStack {
            // Mystical background
            LinearGradient(
                colors: [Color(hex: "1A0033"), Color(hex: "0A0015"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Stars overlay
            GeometryReader { geometry in
                ForEach(0..<60, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.2...0.7)))
                        .frame(width: CGFloat.random(in: 1...2))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero Image Section
                    ZStack(alignment: .bottom) {
                        if card.major {
                            Image("major_\(card.id)")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.clear, Color.black.opacity(0.8), Color.black]),
                                        startPoint: .center,
                                        endPoint: .bottom
                                    )
                                )
                        } else {
                            // Fallback for Minor Arcana
                            ZStack {
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.blue.opacity(0.7)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(height: 150)
                            }
                        }
                        
                        // Title with mystical frame
                        VStack(spacing: 8) {
                            Text("✦")
                                .font(.system(size: 20))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(card.name)
                                .font(.system(size: 38, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                                .shadow(color: .purple.opacity(0.8), radius: 10, x: 0, y: 0)
                                .shadow(color: .black, radius: 4, x: 0, y: 2)
                                .multilineTextAlignment(.center)
                            
                            HStack(spacing: 4) {
                                Text("✦")
                                    .font(.system(size: 8))
                                    .foregroundColor(.white.opacity(0.6))
                                Rectangle()
                                    .fill(Color.white.opacity(0.4))
                                    .frame(width: 40, height: 1)
                                Text("✦")
                                    .font(.system(size: 8))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        .padding(.bottom, 30)
                    }
                    
                    // Content Section
                    VStack(alignment: .leading, spacing: 20) {
                        MysticalSectionView(title: "Descrição", content: card.description, icon: "book.fill")
                        MysticalSectionView(title: "No trabalho", content: card.work, icon: "briefcase.fill")
                        MysticalSectionView(title: "Financeiro", content: card.financial, icon: "dollarsign.circle.fill")
                        MysticalSectionView(title: "Amor", content: card.love, icon: "heart.fill")
                        
                        if let freePerson = card.freePerson {
                            MysticalSectionView(title: "Pessoas livres", content: freePerson, icon: "person.fill")
                        }
                        if let takenPerson = card.takenPerson {
                            MysticalSectionView(title: "Pessoas compromissadas", content: takenPerson, icon: "person.2.fill")
                        }
                        
                        MysticalSectionView(title: "Obstáculo", content: card.obstacle, icon: "exclamationmark.triangle.fill")
                        MysticalSectionView(title: "Conselho", content: card.advice, icon: "star.fill")
                        
                        // Footer symbol
                        Text("✧")
                            .font(.system(size: 24))
                            .foregroundColor(.purple.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct MysticalSectionView: View {
    let title: String
    let content: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.purple.opacity(0.8))
                    .font(.system(size: 18))
                
                Text(title)
                    .font(.system(.title3, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(.gray)
                .lineSpacing(6)
            
            // Mystical divider
            HStack(spacing: 4) {
                Text("✦")
                    .font(.system(size: 6))
                    .foregroundColor(.purple.opacity(0.5))
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.purple.opacity(0.5), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CardView(card: .init(id: 0, major: true, suit: nil, name: "O Mago", description: "Ousadia", work: "Ousadia", financial: "Ousadia", love: "Ousadia", obstacle: "Ousadia", advice: "Ousadia", freePerson: "Ousadia", takenPerson: "Ousadia"))
}
