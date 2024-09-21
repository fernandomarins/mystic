//
//  AstrologyView.swift
//  tarot
//
//  Created by Fernando Marins on 25/09/24.
//

import SwiftUI

struct AstrologyView: View {
    @Environment(\.colorScheme) var colorScheme

    let planet: [String: String]
    let name: String

    init(planet: [String: String], name: String) {
        self.planet = planet
        self.name = name
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(name)
                .font(.title)
            Text(description(for: name))
                .padding(.top, 6)
        }
        .padding(16)
        
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(planet.sorted(by: { $0.key < $1.key }), id: \.key) { sign, description in
                        VStack(alignment: .leading) {
                            Text(convertName(name: sign))
                                .font(.headline)
                            Text(description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
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

#Preview {
    AstrologyView(planet: [:], name: "")
}
