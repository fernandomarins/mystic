//
//  TarotCardCell.swift
//  tarot
//
//  Created by Fernando Marins on 22/11/24.
//

import SwiftUI

struct TarotCardCell: View {
    let card: CardModel
    
    var body: some View {
        ZStack {
            // Card Background (Dark Neutral)
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1C1C1E")) // Dark Grey/Black
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "D4AF37").opacity(0.6), Color(hex: "D4AF37").opacity(0.2)]), // Gold
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.5), radius: 6, x: 0, y: 4)
            
            VStack(spacing: 0) {
                // Image Area (Top 75%)
                GeometryReader { geometry in
                    if card.major {
                        Image("major_\(card.id)")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, Color(hex: "1C1C1E")]),
                                    startPoint: .center,
                                    endPoint: .bottom
                                )
                            )
                    } else {
                        // Fallback for Minor Arcana
                        ZStack {
                            Color.black.opacity(0.3)
                            Image(systemName: "sparkles")
                                .font(.system(size: 30, weight: .light))
                                .foregroundColor(Color(hex: "D4AF37").opacity(0.3))
                        }
                    }
                }
                .frame(height: 160) // Fixed height for image area
                
                // Text Area (Bottom 25%)
                VStack(spacing: 4) {
                    Text(card.name)
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundColor(Color(hex: "E5E5EA")) // Light Grey/White
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    
                    if let suit = card.suit {
                        Text(suitSymbol(for: suit))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "1C1C1E"))
            }
            .cornerRadius(16)
        }
        .frame(height: 240) // Increased height slightly
    }
    
    private func suitSymbol(for suit: CardSuit) -> String {
        switch suit {
        case .diamonds: return "♦️"
        case .hearts: return "❤️"
        case .spades: return "♠️"
        case .clubs: return "♣️"
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    TarotCardCell(card: CardModel(id: 0, major: true, suit: nil, name: "O Mago", description: "Ousadia", work: "Ousadia", financial: "Ousadia", love: "Ousadia", obstacle: "Ousadia", advice: "Ousadia", freePerson: "Ousadia", takenPerson: "Ousadia"))
        .padding()
}
