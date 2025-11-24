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
        ("Sol", "☉"),
        ("Lua", "☽"),
        ("Mercúrio", "☿"),
        ("Vênus", "♀"),
        ("Marte", "♂"),
        ("Júpiter", "♃"),
        ("Saturno", "♄"),
        ("Urano", "♅"),
        ("Netuno", "♆"),
        ("Plutão", "♇")
    ]
    
    private let zodiacSigns = [
        ("Áries", "♈"),
        ("Touro", "♉"),
        ("Gêmeos", "♊"),
        ("Câncer", "♋"),
        ("Leão", "♌"),
        ("Virgem", "♍"),
        ("Libra", "♎"),
        ("Escorpião", "♏"),
        ("Sagitário", "♐"),
        ("Capricórnio", "♑"),
        ("Aquário", "♒"),
        ("Peixes", "♓")
    ]
    
    @State private var selectedPlanet = "Planeta"
    @State private var selectedSign = "Signo"
    
    private var canSave: Bool {
        selectedPlanet != "Planeta" && selectedSign != "Signo"
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
        ZStack {
            // Cosmic background
            LinearGradient(
                colors: [Color(hex: "1A0033"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Title
                Text(mode == .add ? "Adicionar Planeta" : "Editar Planeta")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                // Planet Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Planeta")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Menu {
                        ForEach(planets, id: \.0) { planet in
                            Button(planet.0) {
                                selectedPlanet = planet.0
                            }
                        }
                    } label: {
                        HStack {
                            if let planet = planets.first(where: { $0.0 == selectedPlanet }) {
                                Text(planet.1)
                                Text(planet.0)
                            } else {
                                Text(selectedPlanet)
                            }
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "1C1C1E"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(.horizontal)
                
                // Sign Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Signo")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Menu {
                        ForEach(zodiacSigns, id: \.0) { sign in
                            Button(sign.0) {
                                selectedSign = sign.0
                            }
                        }
                    } label: {
                        HStack {
                            if let sign = zodiacSigns.first(where: { $0.0 == selectedSign }) {
                                Text(sign.1)
                                Text(sign.0)
                            } else {
                                Text(selectedSign)
                            }
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "1C1C1E"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Save Button
                Button(action: {
                    onSelected((selectedPlanet, selectedSign))
                    dismiss()
                }) {
                    Text(mode == .add ? "Adicionar" : "Salvar")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: canSave ? [Color.purple, Color.blue] : [Color.gray, Color.gray],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
                .disabled(!canSave)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    SelectPlanetView(mode: .add, onSelected: { _ in })
}
