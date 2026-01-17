//
//  GeomanciaHouseSumView.swift
//  tarot
//
//  Created by Antigravity on 17/01/26.
//

import SwiftUI

struct GeomanciaHouseSumView: View {
    @ObservedObject var viewModel: GeomanciaReadingViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var house1: Int = 1
    @State private var house2: Int = 7
    @State private var sumResult: (pattern: [Int], meaning: GeomanciaMeaning?)? = nil
    
    private let accentGold = Color(hex: "D4AF37")
    private let bgGradient = LinearGradient(
        colors: [Color(hex: "1B1212"), Color(hex: "2D1B10")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        ZStack {
            bgGradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Soma de Casas")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                        Text("Síntese Geomântica")
                            .font(.system(size: 14))
                            .foregroundColor(accentGold.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                            .padding(10)
                            .background(Circle().fill(.white.opacity(0.1)))
                    }
                }
                .padding(25)
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Info Card
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SOBRE ESTA TÉCNICA")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(accentGold)
                                .tracking(2)
                            
                            Text("A soma de duas casas revela uma figura que representa a síntese ou o resultado da interação entre essas duas áreas da vida.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .lineSpacing(4)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.03)))
                        .padding(.horizontal, 20)
                        
                        // Selection Card
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Selecione Duas Casas")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            
                            // First House Picker
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Primeira Casa")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Menu {
                                    ForEach(1...12, id: \.self) { houseId in
                                        Button(houseLabel(for: houseId)) {
                                            house1 = houseId
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(houseLabel(for: house1))
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(accentGold)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.05))
                                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(accentGold.opacity(0.3), lineWidth: 1))
                                    )
                                }
                            }
                            
                            // Second House Picker
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Segunda Casa")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Menu {
                                    ForEach(1...12, id: \.self) { houseId in
                                        Button(houseLabel(for: houseId)) {
                                            house2 = houseId
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(houseLabel(for: house2))
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(accentGold)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.05))
                                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(accentGold.opacity(0.3), lineWidth: 1))
                                    )
                                }
                            }
                            
                            Button(action: calculateSum) {
                                Text("Calcular Soma")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        Capsule()
                                            .fill(accentGold)
                                            .shadow(color: accentGold.opacity(0.3), radius: 10)
                                    )
                            }
                        }
                        .padding(20)
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.03)))
                        .padding(.horizontal, 20)
                        
                        // Result Card
                        if let result = sumResult {
                            VStack(spacing: 20) {
                                Text("Resultado da Soma")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                                    .tracking(1)
                                
                                // Display the summed figure
                                GeomanticSymbolView(
                                    pattern: result.pattern,
                                    color: accentGold,
                                    dotSize: 14,
                                    spacing: 14
                                )
                                .padding(.vertical, 10)
                                
                                if let meaning = result.meaning {
                                    VStack(spacing: 12) {
                                        Text(meaning.name)
                                            .font(.system(size: 28, weight: .bold, design: .serif))
                                            .foregroundColor(.white)
                                        
                                        Text(meaning.latinName)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(accentGold)
                                            .italic()
                                        
                                        Divider()
                                            .background(Color.white.opacity(0.2))
                                            .padding(.vertical, 4)
                                        
                                        Text(meaning.meaning)
                                            .font(.body)
                                            .foregroundColor(.white.opacity(0.9))
                                            .multilineTextAlignment(.center)
                                            .lineSpacing(4)
                                            .padding(.horizontal)
                                        
                                        HStack(spacing: 16) {
                                            if let planet = meaning.planet {
                                                HStack(spacing: 4) {
                                                    Image(systemName: "sparkles")
                                                        .font(.caption)
                                                    Text(planet)
                                                        .font(.caption)
                                                }
                                                .foregroundColor(.white.opacity(0.6))
                                            }
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "flame")
                                                    .font(.caption)
                                                Text(meaning.element)
                                                    .font(.caption)
                                            }
                                            .foregroundColor(.white.opacity(0.6))
                                        }
                                        .padding(.top, 8)
                                    }
                                } else {
                                    Text("Figura não encontrada")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(20)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.05)))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(accentGold.opacity(0.3), lineWidth: 2))
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private func houseLabel(for id: Int) -> String {
        if let house = viewModel.housesData.first(where: { $0.id == id }) {
            let parts = house.name.components(separatedBy: ":")
            if parts.count > 1 {
                return "Casa \(id): \(parts[1].trimmingCharacters(in: .whitespaces))"
            }
        }
        return "Casa \(id)"
    }
    
    private func calculateSum() {
        let pattern1 = viewModel.figurePattern(forHouse: house1)
        let pattern2 = viewModel.figurePattern(forHouse: house2)
        
        // Sum the two patterns using geomantic addition
        let summedPattern = zip(pattern1, pattern2).map { (v1, v2) in
            (v1 + v2) % 2 == 0 ? 2 : 1
        }
        
        let meaning = viewModel.meaning(for: summedPattern)
        withAnimation {
            sumResult = (pattern: summedPattern, meaning: meaning)
        }
    }
}
