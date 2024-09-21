//
//  SelectPlanetView.swift
//  tarot
//
//  Created by Fernando Marins on 25/09/24.
//

import SwiftUI

enum FormMode: Equatable {
    case add
    case edit(planet: String, sign: String)
}

struct SelectPlanetView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let planets = [
        "Sol",
        "Lua",
        "Mercúrio",
        "Vênus",
        "Marte",
        "Júpiter",
        "Saturno",
        "Urano",
        "Netuno",
        "Plutão"
    ]
    
    private let zodiacSigns = [
        "Áries",
        "Touro",
        "Gêmeos",
        "Câncer",
        "Leão",
        "Virgem",
        "Libra",
        "Escorpião",
        "Sagitário",
        "Capricórnio",
        "Aquário",
        "Peixes"
    ]
    
    @State private var selectedPlanet = "Planeta"
    @State private var selectedSign = "Signo"
    
    private var selectionMessage: String? {
        switch (selectedPlanet, selectedSign) {
        case ("Planeta", "Signo"):
            return "Selecione um planeta e um signo"
        case ("Planeta", _):
            return "Selecione um planeta"
        case (_, "Signo"):
            return "Selecione um signo"
        default:
            return nil
        }
    }
    
    private var buttonColor: Color {
        (selectedPlanet == "Planeta" || selectedSign == "Signo") ? .gray : .white
    }
    
    let mode: FormMode
    let onSelected: ((planet: String, sign: String)) -> Void
    
    init(mode: FormMode, onSelected: @escaping ((planet: String, sign: String)) -> Void) {
        self.mode = mode
        self.onSelected = onSelected
        
        switch mode {
        case .edit(let planet, let sign):
            _selectedPlanet = State(initialValue: planet)
            _selectedSign = State(initialValue: sign)
        case .add:
            break
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            selectionMenu(
                title: "Selecione o planeta",
                selection: $selectedPlanet, options: planets
            )
            selectionMenu(
                title: "Selecione o signo",
                selection: $selectedSign, options: zodiacSigns
            )
        }
        .padding(16)
        VStack(alignment: .center) {
            Button(mode == .add ? "Adicionar" : "Salvar") {
                onSelected((selectedPlanet, selectedSign))
                dismiss.callAsFunction()
            }
            .foregroundStyle(buttonColor)
            .bold()
            .font(.title)
            .padding(.top, 60)
            .disabled(selectedPlanet == "Planeta" || selectedSign == "Signo")
            if let message = selectionMessage {
                Text(message)
                    .font(.caption)
            }
        }
    }
    
    private func selectionMenu(
        title: String,
        selection: Binding<String>,
        options: [String]
    ) -> some View {
        HStack {
            Text(title)
                .font(.title3)
                .bold()
                .foregroundColor(.white)
            Spacer()
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selection.wrappedValue = option
                    }
                    .foregroundColor(.white)
                }
            } label: {
                Text(selection.wrappedValue)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    SelectPlanetView(mode: .add, onSelected: { _ in })
}
