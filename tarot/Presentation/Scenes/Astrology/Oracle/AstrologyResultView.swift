//
//  AstrologyResultView.swift
//  tarot
//
//  Created by Fernando Marins on 25/09/24.
//

import SwiftUI

struct AstrologyResultView: View {
    @State private var isShowingSheet = false
    @State private var selectedElements: [AstrologyInfo] = []
    @State private var formMode: FormMode = .add
    @State private var selectedElementIndex: Int? = nil
    
    let model: AstrologyModel
    
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
            
            VStack(spacing: 20) {
                if !selectedElements.isEmpty {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(Array(selectedElements.enumerated()), id: \.element.id) { index, element in
                                PlanetSignCard(
                                    element: element,
                                    dignity: dignityCheck(planet: element.planet, sign: element.sign),
                                    description: getDefinition(planet: element.planet, sign: element.sign),
                                    planetDescription: description(for: element.planet)
                                )
                                .onTapGesture {
                                    selectedElementIndex = index
                                    formMode = .edit(planet: element.planet, sign: element.sign)
                                    isShowingSheet = true
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    Spacer()
                    
                    VStack(spacing: 30) {
                        // Cosmic illustration
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [Color.purple.opacity(0.3), Color.clear],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 100
                                    )
                                )
                                .frame(width: 200, height: 200)
                            
                            Text("🌌")
                                .font(.system(size: 80))
                        }
                        
                        Text("Crie sua leitura astrológica")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Adicione planetas e signos para começar")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    Spacer()
                }
                
                // Floating Add Button
                Button(action: {
                    formMode = .add
                    isShowingSheet = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text(selectedElements.isEmpty ? "Adicionar Planeta" : "Adicionar Mais")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color.purple, Color.blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(30)
                    .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            SelectPlanetView(mode: formMode) { selectedElement in
                switch formMode {
                case .add:
                    selectedElements.append(.init(planet: selectedElement.planet, sign: selectedElement.sign))
                case .edit(_, _):
                    if let index = selectedElementIndex {
                        selectedElements[index] = .init(planet: selectedElement.planet, sign: selectedElement.sign)
                    }
                    formMode = .add
                }
            }
            .presentationDetents([.medium])
        }
        .toolbar {
            if !selectedElements.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        selectedElements.removeAll()
                    }) {
                        Text("Limpar")
                            .foregroundColor(.purple)
                    }
                }
            }
        }
        .swipeActions(allowsFullSwipe: true) {
            ForEach(Array(selectedElements.enumerated()), id: \.element.id) { index, _ in
                Button(role: .destructive) {
                    selectedElements.remove(at: index)
                } label: {
                    Label("Deletar", systemImage: "trash")
                }
            }
        }
        .backButtonStyle()
    }
    
    private func getDefinition(planet: String, sign: String) -> String {
        switch planet {
        case "Sol":
            return model.planets.sunSigns[convertToEnglish(name: sign)] ?? ""
        case "Lua":
            return model.planets.moonSigns[convertToEnglish(name: sign)] ?? ""
        case "Mercúrio":
            return model.planets.mercurySigns[convertToEnglish(name: sign)] ?? ""
        case "Vênus":
            return model.planets.venusSigns[convertToEnglish(name: sign)] ?? ""
        case "Marte":
            return model.planets.marsSigns[convertToEnglish(name: sign)] ?? ""
        case "Júpiter":
            return model.planets.jupiterSigns[convertToEnglish(name: sign)] ?? ""
        case "Saturno":
            return model.planets.saturnSigns[convertToEnglish(name: sign)] ?? ""
        case "Urano":
            return model.planets.uranusSigns[convertToEnglish(name: sign)] ?? ""
        case "Netuno":
            return model.planets.neptuneSigns[convertToEnglish(name: sign)] ?? ""
        case "Plutão":
            return model.planets.plutoSigns[convertToEnglish(name: sign)] ?? ""
        default:
            return ""
        }
    }
    
    private func convertToEnglish(name: String) -> String {
        switch name {
        case "Áries":
            return "aries"
        case "Touro":
            return "taurus"
        case "Gêmeos":
            return "gemini"
        case "Câncer":
            return "cancer"
        case "Leão":
            return "leo"
        case "Virgem":
            return "virgo"
        case "Libra":
            return "libra"
        case "Escorpião":
            return "scorpio"
        case "Sagitário":
            return "sagittarius"
        case "Capricórnio":
            return "capricorn"
        case "Aquário":
            return "aquarius"
        case "Peixes":
            return "pisces"
        default:
            return ""
        }
    }
    
    private func description(for name: String) -> String {
        switch name {
        case "Sol":
            return "A pessoa em si."
        case "Lua":
            return "Como se sente, influência emocional."
        case "Mercúrio":
            return "Como pensa, influência mental."
        case "Vênus":
            return "Poder de atração, influência de relações."
        case "Marte":
            return "Como conquista, poder de conquistar e agir."
        case "Júpiter":
            return "Poder de expansão."
        case "Saturno":
            return "Responsabilidade, limitações, autosabotagem, lições, onde precisamos amadurecer através da disciplina e esforço."
        case "Urano":
            return "Inovação, quebra de padrões e a busca por novas formas de ver o mundo, onde somos impulsionados a evoluir de maneira única."
        case "Netuno":
            return "Espiritualidade, inconsciente e ilusão, como podemos ter inspiração profunda, mas também onde podemos nos iludir."
        case "Plutão":
            return "Poder, transformação e renascimento, também podem ser crises ligadas à espiritualidade, fantasia e sacrifício, com uma busca intensa por redenção e compreensão do inconsciente, abuso de autoridade."
        default:
            return ""
        }
    }
    
    private func dignityCheck(planet: String, sign: String) -> Dignity? {
        switch (planet, sign) {
        // Sol
        case ("Sol", "Leão"):
            return .ruler
        case ("Sol", "Aquário"):
            return .detriment
        case ("Sol", "Áries"):
            return .exalted
        case ("Sol", "Libra"):
            return .fall

        // Lua
        case ("Lua", "Câncer"):
            return .ruler
        case ("Lua", "Capricórnio"):
            return .detriment
        case ("Lua", "Touro"):
            return .exalted
        case ("Lua", "Escorpião"):
            return .fall

        // Mercúrio
        case ("Mercúrio", "Gêmeos"), ("Mercúrio", "Virgem"):
            return .ruler
        case ("Mercúrio", "Sagitário"), ("Mercúrio", "Peixes"):
            return .detriment
        case ("Mercúrio", "Aquário"):
            return .exalted
        case ("Mercúrio", "Leão"):
            return .fall

        // Vênus
        case ("Vênus", "Touro"), ("Vênus", "Libra"):
            return .ruler
        case ("Vênus", "Áries"), ("Vênus", "Escorpião"):
            return .detriment
        case ("Vênus", "Peixes"):
            return .exalted
        case ("Vênus", "Virgem"):
            return .fall

        // Marte
        case ("Marte", "Áries"), ("Marte", "Escorpião"):
            return .ruler
        case ("Marte", "Touro"), ("Marte", "Libra"):
            return .detriment
        case ("Marte", "Capricórnio"):
            return .exalted
        case ("Marte", "Câncer"):
            return .fall

        // Júpiter
        case ("Júpiter", "Sagitário"), ("Júpiter", "Peixes"):
            return .ruler
        case ("Júpiter", "Gêmeos"), ("Júpiter", "Virgem"):
            return .detriment
        case ("Júpiter", "Câncer"):
            return .exalted
        case ("Júpiter", "Capricórnio"):
            return .fall

        // Saturno
        case ("Saturno", "Capricórnio"), ("Saturno", "Aquário"):
            return .ruler
        case ("Saturno", "Câncer"), ("Saturno", "Leão"):
            return .detriment
        case ("Saturno", "Libra"):
            return .exalted
        case ("Saturno", "Áries"):
            return .fall

        // Urano
        case ("Urano", "Aquário"):
            return .ruler
        case ("Urano", "Leão"):
            return .detriment
        case ("Urano", "Escorpião"):
            return .exalted
        case ("Urano", "Touro"):
            return .fall

        // Netuno
        case ("Netuno", "Peixes"):
            return .ruler
        case ("Netuno", "Virgem"):
            return .detriment
        case ("Netuno", "Câncer"):
            return .exalted
        case ("Netuno", "Capricórnio"):
            return .fall

        // Plutão
        case ("Plutão", "Escorpião"):
            return .ruler
        case ("Plutão", "Touro"):
            return .detriment
        case ("Plutão", "Leão"):
            return .exalted
        case ("Plutão", "Aquário"):
            return .fall

        default:
            return nil
        }
    }
}

struct PlanetSignCard: View {
    let element: AstrologyInfo
    let dignity: Dignity?
    let description: String
    let planetDescription: String
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Planet and Sign
                HStack(spacing: 8) {
                    Text(planetSymbol(element.planet))
                        .font(.title)
                    Text(element.planet)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("-")
                        .foregroundColor(.gray)
                    Text(signSymbol(element.sign))
                        .font(.title)
                    Text(element.sign)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Dignity Badge
                if let dignity = dignity {
                    DignitiesView(dignity: dignity)
                }
            }
            
            // Planet Description
            Text(planetDescription)
                .font(.caption)
                .foregroundColor(.gray)
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            // Full Description
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
}

#Preview {
    AstrologyResultView(model: .init(planets: .init(sunSigns: [:], moonSigns: [:], mercurySigns: [:], venusSigns: [:], marsSigns: [:], jupiterSigns: [:], saturnSigns: [:], uranusSigns: [:], neptuneSigns: [:], plutoSigns: [:])))
}
