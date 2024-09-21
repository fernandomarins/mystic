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
    
    private var buttonDimension: Double {
        selectedElements.isEmpty ? 80 : 20
    }
    
    private var textFont: Font {
        selectedElements.isEmpty ? .title : .headline
    }
    
    private var disableClearButton: Bool {
        selectedElements.isEmpty
    }
    
    let model: AstrologyModel
    
    init(model: AstrologyModel) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            if !selectedElements.isEmpty {
                List {
                    ForEach(Array(selectedElements.enumerated()), id: \.element.id) { index, element in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(element.planet) - \(element.sign)")
                                    .font(.title3)
                                    .bold()
                                if let dignity = dignityCheck(planet: element.planet, sign: element.sign) {
                                    Spacer()
                                    DignitiesView(dignity: dignity)
                                }
                            }

                            Text(description(for: element.planet))
                                .foregroundStyle(.gray)
                                .font(.caption)
                            Spacer()
                            Text(getDefinition(
                                planet: element.planet,
                                sign: element.sign
                            ))
                        }
                        .onTapGesture {
                            selectedElementIndex = index
                            formMode = .edit(planet: element.planet, sign: element.sign)
                            isShowingSheet = true
                        }
                        .padding()
                    }
                    .onDelete { indexSet in
                        selectedElements.remove(atOffsets: indexSet)
                    }
                }
            }
            VStack {
                Text("Clique abaixo para adicionar os planetas")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 60)
                Button(action: {
                    isShowingSheet = true
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: buttonDimension, height: buttonDimension)
                        .foregroundStyle(.white)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedElements.isEmpty)
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
            clear
        }
    }
    
    @ToolbarContentBuilder
    private var clear: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                clearSelections()
            }) {
                Text("Limpar seleção")
            }
            .disabled(disableClearButton)
        }
    }
    
    private func clearSelections() {
        selectedElements.removeAll()
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

#Preview {
    AstrologyResultView(model: .init(planets: .init(sunSigns: [:], moonSigns: [:], mercurySigns: [:], venusSigns: [:], marsSigns: [:], jupiterSigns: [:], saturnSigns: [:], uranusSigns: [:], neptuneSigns: [:], plutoSigns: [:])))
}
