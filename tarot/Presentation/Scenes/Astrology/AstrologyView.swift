//
//  AstrologyView.swift
//  tarot
//
//  Created by Fernando Marins on 25/09/24.
//

import SwiftUI

struct AstrologyView: View {
    let planet: [String: String]
    let name: String
    
    var body: some View {
        ZStack {
            // Cosmic background
            LinearGradient(
                colors: [Color(hex: "1A0033"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Stars overlay
            GeometryReader { geometry in
                ForEach(0..<50, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.3...0.8)))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Hero Section
                    VStack(spacing: 12) {
                        Text(planetSymbol(name))
                            .font(.system(size: 80))
                            .shadow(color: planetColor(name).opacity(0.8), radius: 20, x: 0, y: 0)
                        
                        Text(name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(description(for: name))
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    // Zodiac Signs
                    VStack(spacing: 16) {
                        ForEach(planet.sorted(by: { $0.key < $1.key }), id: \.key) { sign, description in
                            ZodiacSignCard(
                                sign: convertName(name: sign),
                                signSymbol: signSymbol(convertName(name: sign)),
                                description: description
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func planetSymbol(_ planet: String) -> String {
        switch planet {
        case "Sol": return "☉"
        case "Lua": return "☽"
        case "Mercúrio": return "☿"
        case "Vênus": return "♀"
        case "Marte": return "♂"
        case "Júpiter": return "♃"
        case "Saturno": return "♄"
        case "Urano": return "♅"
        case "Netuno": return "♆"
        case "Plutão": return "♇"
        default: return ""
        }
    }
    
    private func planetColor(_ planet: String) -> Color {
        switch planet {
        case "Sol": return Color(hex: "FFD700")
        case "Lua": return Color(hex: "E8E8E8")
        case "Mercúrio": return Color(hex: "FF8C00")
        case "Vênus": return Color(hex: "FF69B4")
        case "Marte": return Color(hex: "DC143C")
        case "Júpiter": return Color(hex: "9370DB")
        case "Saturno": return Color(hex: "DAA520")
        case "Urano": return Color(hex: "00CED1")
        case "Netuno": return Color(hex: "4169E1")
        case "Plutão": return Color(hex: "8B008B")
        default: return .white
        }
    }
    
    private func signSymbol(_ sign: String) -> String {
        switch sign {
        case "Áries": return "♈"
        case "Touro": return "♉"
        case "Gêmeos": return "♊"
        case "Câncer": return "♋"
        case "Leão": return "♌"
        case "Virgem": return "♍"
        case "Libra": return "♎"
        case "Escorpião": return "♏"
        case "Sagitário": return "♐"
        case "Capricórnio": return "♑"
        case "Aquário": return "♒"
        case "Peixes": return "♓"
        default: return ""
        }
    }
    
    private func description(for name: String) -> String {
        let descriptions: [String: String] = [
            "Sol": "A pessoa em si.",
            "Lua": "Como se sente, influência emocional.",
            "Mercúrio": "Como pensa, influência mental.",
            "Vênus": "Poder de atração, influência de relações.",
            "Marte": "Como conquista, poder de conquistar e agir.",
            "Júpiter": "Poder de expansão.",
            "Saturno": "Responsabilidade, limitações, autosabotagem, lições, onde precisamos amadurecer através da disciplina e esforço.",
            "Urano": "Inovação, quebra de padrões e a busca por novas formas de ver o mundo, onde somos impulsionados a evoluir de maneira única.",
            "Netuno": "Espiritualidade, inconsciente e ilusão, como podemos ter inspiração profunda, mas também onde podemos nos iludir.",
            "Plutão": "Poder, transformação e renascimento, também podem ser crises ligadas à espiritualidade, fantasia e sacrifício, com uma busca intensa por redenção e compreensão do inconsciente, abuso de autoridade."
        ]
        return descriptions[name, default: ""]
    }
    
    private func convertName(name: String) -> String {
        let nameMapping: [String: String] = [
            "aries": "Áries",
            "taurus": "Touro",
            "gemini": "Gêmeos",
            "cancer": "Câncer",
            "leo": "Leão",
            "virgo": "Virgem",
            "libra": "Libra",
            "scorpio": "Escorpião",
            "sagittarius": "Sagitário",
            "capricorn": "Capricórnio",
            "aquarius": "Aquário",
            "pisces": "Peixes"
        ]
        return nameMapping[name, default: ""]
    }
}

struct ZodiacSignCard: View {
    let sign: String
    let signSymbol: String
    let description: String
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(signSymbol)
                    .font(.title)
                Text(sign)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Text(description)
                .font(.body)
                .foregroundColor(.white)
                .lineLimit(isExpanded ? nil : 3)
            
            if description.count > 150 {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Text(isExpanded ? "Ver menos" : "Ver mais")
                        .font(.caption)
                        .foregroundColor(.purple)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1C1C1E"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    AstrologyView(planet: [:], name: "")
}
