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
            // Card Background
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "2C003E"), Color(hex: "000000")]), // Deep Purple to Black
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.yellow.opacity(0.6), Color.clear, Color.yellow.opacity(0.6)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: .black.opacity(0.5), radius: 6, x: 0, y: 4)
            
            // Decorative Inner Border
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                .padding(6)
            
            // Central Content
            VStack(spacing: 12) {
                Spacer()
                
                // Decorative Top Icon
                Image(systemName: "sparkles")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.yellow.opacity(0.7))
                
                // Card Name (The Art)
                Text(card.name)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(.white.opacity(0.95))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
                    .shadow(color: .yellow.opacity(0.2), radius: 8, x: 0, y: 0)
                    .minimumScaleFactor(0.5) // Allow scaling down for long names
                
                // Decorative Bottom Icon or Suit
                if let suit = card.suit {
                    Text(suitSymbol(for: suit))
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.6))
                } else {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.yellow.opacity(0.5))
                }
                
                Spacer()
            }
            .padding()
        }
        .frame(height: 220)
        .aspectRatio(2/3, contentMode: .fit)
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
