//
//  AstrologyListView.swift
//  tarot
//
//  Created by Fernando Marins on 25/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct AstrologyListView: View {
    @StateObject private var viewModel = AstrologyViewModel()
    @State private var hasFetchedData: Bool = false
    
    private let planets = [
        ("Sol", "☉", [Color(hex: "FFD700"), Color(hex: "FFA500")]),
        ("Lua", "☽", [Color(hex: "E8E8E8"), Color(hex: "C0C0C0")]),
        ("Mercúrio", "☿", [Color(hex: "FF8C00"), Color(hex: "FF6347")]),
        ("Vênus", "♀", [Color(hex: "FF69B4"), Color(hex: "FF1493")]),
        ("Marte", "♂", [Color(hex: "DC143C"), Color(hex: "8B0000")]),
        ("Júpiter", "♃", [Color(hex: "9370DB"), Color(hex: "8A2BE2")]),
        ("Saturno", "♄", [Color(hex: "DAA520"), Color(hex: "B8860B")]),
        ("Urano", "♅", [Color(hex: "00CED1"), Color(hex: "4682B4")]),
        ("Netuno", "♆", [Color(hex: "4169E1"), Color(hex: "191970")]),
        ("Plutão", "♇", [Color(hex: "8B008B"), Color(hex: "4B0082")])
    ]
    
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
            
            if viewModel.isLoading {
                LoadingIndicator(
                    animation: .circleBars,
                    color: .white,
                    size: .large
                )
            } else if let model = viewModel.astrology {
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Planetas")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                            ForEach(planets, id: \.0) { planet in
                                let description = getDescription(for: planet.0, in: model.planets)
                                
                                if let description = description {
                                    NavigationLink(destination: AstrologyView(
                                        planet: description,
                                        name: planet.0)
                                    ) {
                                        PlanetCard(
                                            name: planet.0,
                                            symbol: planet.1,
                                            colors: planet.2
                                        )
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.fetchAstrology()
                    }
                }
            } else {
                Text("Nenhum planeta encontrado.")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            if !hasFetchedData {
                Task {
                    await viewModel.fetchAstrology()
                    hasFetchedData = true
                }
            }
        }
        .toolbar {
            oracleView
        }
        .backButtonStyle()
    }
    
    @ToolbarContentBuilder
    private var oracleView: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            if let model = viewModel.astrology {
                NavigationLink(destination: AstrologyResultView(model: model)) {
                    Text("Leitura")
                        .foregroundColor(.purple)
                }
            }
        }
    }
    
    private func getDescription(for planet: String, in planets: Planets) -> [String: String]? {
        switch planet {
        case "Sol":
            return planets.sunSigns
        case "Lua":
            return planets.moonSigns
        case "Mercúrio":
            return planets.mercurySigns
        case "Vênus":
            return planets.venusSigns
        case "Marte":
            return planets.marsSigns
        case "Júpiter":
            return planets.jupiterSigns
        case "Saturno":
            return planets.saturnSigns
        case "Urano":
            return planets.uranusSigns
        case "Netuno":
            return planets.neptuneSigns
        case "Plutão":
            return planets.plutoSigns
        default:
            return nil
        }
    }
}

struct PlanetCard: View {
    let name: String
    let symbol: String
    let colors: [Color]
    
    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: colors[0].opacity(0.5), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 12) {
                // Planet symbol
                Text(symbol)
                    .font(.system(size: 60))
                    .shadow(color: .white.opacity(0.8), radius: 10, x: 0, y: 0)
                
                // Planet name
                Text(name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
            }
            .padding()
        }
        .frame(height: 160)
    }
}

#Preview {
    AstrologyListView()
}
