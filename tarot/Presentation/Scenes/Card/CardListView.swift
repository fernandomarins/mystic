//
//  ContentView.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators
import SwiftData

struct CardListView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject private var viewModel = CardViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

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
                ForEach(0..<80, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.3...0.8)))
                        .frame(width: CGFloat.random(in: 1...2.5))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
            .ignoresSafeArea()
            
            if viewModel.isLoading {
                LoadingIndicator(
                    animation: .circleBars,
                    color: .white,
                    size: .large
                )
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        // Mystical Header
                        VStack(spacing: 8) {
                            Text("✦")
                                .font(.system(size: 32))
                                .foregroundColor(.purple.opacity(0.8))
                            
                            Text("Arcanos")
                                .font(.system(size: 36, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                                .shadow(color: .purple.opacity(0.5), radius: 8, x: 0, y: 0)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                        
                        // Major Arcana Section (Full Width)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Arcanos Maiores")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.leading, 4)
                            
                            TarotGroupCell(
                                title: "Arcanos Maiores",
                                icon: "🌟",
                                cards: viewModel.cards.filter { $0.major },
                                colors: [Color(hex: "FFD700"), Color(hex: "8B4513")]
                            )
                        }
                        .padding(.bottom, 10)
                        
                        // Minor Arcana Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Arcanos Menores")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.leading, 4)
                            
                            LazyVGrid(columns: columns, spacing: 20) {
                                TarotGroupCell(
                                    title: "Paus",
                                    icon: "🔥",
                                    cards: viewModel.cards.filter { $0.suit == .clubs },
                                    colors: [Color(hex: "FF6B35"), Color(hex: "8B0000")]
                                )
                                TarotGroupCell(
                                    title: "Copas",
                                    icon: "💧",
                                    cards: viewModel.cards.filter { $0.suit == .hearts },
                                    colors: [Color(hex: "4A90E2"), Color(hex: "1A237E")]
                                )
                                TarotGroupCell(
                                    title: "Ouros",
                                    icon: "💎",
                                    cards: viewModel.cards.filter { $0.suit == .diamonds },
                                    colors: [Color(hex: "FFD700"), Color(hex: "B8860B")]
                                )
                                TarotGroupCell(
                                    title: "Espadas",
                                    icon: "⚔️",
                                    cards: viewModel.cards.filter { $0.suit == .spades },
                                    colors: [Color(hex: "C0C0C0"), Color(hex: "4A4A4A")]
                                )
                            }
                        }
                        
                        // Footer symbol
                        Text("✧")
                            .font(.system(size: 20))
                            .foregroundColor(.purple.opacity(0.5))
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 20)
                    }
                    .padding()
                }
                .refreshable {
                    Task {
                        await viewModel.fetchCards(context: modelContext)
                    }
                }
            }
        }
        .onAppear {
            if viewModel.cards.isEmpty {
                Task {
                    await viewModel.fetchCards(context: modelContext)
                }
            }
        }
        .backButtonStyle()
    }
}

struct TarotGroupCell: View {
    let title: String
    let icon: String
    let cards: [CardModel]
    let colors: [Color]
    
    @State private var isGlowing = false
    
    var body: some View {
        NavigationLink(destination: SuitListView(title: "\(title) \(icon)", cards: cards)) {
            ZStack {
                // Outer glow
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        RadialGradient(
                            colors: [colors.first?.opacity(0.2) ?? .clear, .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .blur(radius: 15)
                    .opacity(isGlowing ? 0.5 : 0.2)
                
                // Card Background
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: colors),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .opacity(0.25) // Reduced opacity to blend with background
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.3), .white.opacity(0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: colors.first?.opacity(0.2) ?? .clear, radius: 12, x: 0, y: 6)
                
                VStack(spacing: 12) {
                    // Icon with glow
                    ZStack {
                        Text(icon)
                            .font(.system(size: 50))
                            .blur(radius: 8)
                            .opacity(0.6)
                        
                        Text(icon)
                            .font(.system(size: 50))
                    }
                    
                    Text(title)
                        .font(.system(.headline, design: .serif))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                    
                    // Mystical divider
                    HStack(spacing: 3) {
                        Text("✦")
                            .font(.system(size: 6))
                            .foregroundColor(.white.opacity(0.7))
                        Rectangle()
                            .fill(Color.white.opacity(0.4))
                            .frame(width: 25, height: 1)
                        Text("✦")
                            .font(.system(size: 6))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding()
            }
            .frame(height: 160)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 2.5)
                        .repeatForever(autoreverses: true)
                ) {
                    isGlowing = true
                }
            }
        }
    }
}

#Preview {
    CardListView()
}
