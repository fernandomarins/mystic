//
//  AstrologyListView.swift
//  tarot
//
//  Created by Fernando Marins on 25/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators
import SwiftData

struct AstrologyListView: View {
    @Environment(\.modelContext) var modelContext
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
            } else if !viewModel.planets.isEmpty {
                ScrollView {
                    VStack(spacing: 24) {
                        Text("Planetas")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                            ForEach(planets, id: \.0) { planet in
                                let description = getDescription(for: planet.0, in: viewModel.planets)
                                
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
                        await viewModel.fetchAstrology(context: modelContext)
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
                    await viewModel.fetchAstrology(context: modelContext)
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
            if !viewModel.planets.isEmpty {
                NavigationLink(destination: AstrologyResultView(planets: viewModel.planets)) {
                    Text("Leitura")
                        .foregroundColor(.purple)
                }
            }
        }
    }
    
    private func getDescription(for planet: String, in planets: [PlanetEntity]) -> [String: String]? {
        return planets.first(where: { $0.name == planet })?.signDescriptions
    }
}

struct PlanetCard: View {
    let name: String
    let symbol: String
    let colors: [Color]
    
    var body: some View {
        ZStack {
            // Planet Visual Background
            PlanetVisual(name: name)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: colors[0].opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 12) {
                // Planet symbol
                Text(symbol)
                    .font(.system(size: 60))
                    .foregroundColor(.white) // Cosmic White
                    .shadow(color: .purple.opacity(0.8), radius: 10, x: 0, y: 0) // Cosmic Glow
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                
                // Planet name
                Text(name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 1)
            }
            .padding()
        }
        .frame(height: 160)
    }
}

struct PlanetVisual: View {
    let name: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base background - Semi-transparent
                Color.black.opacity(0.4)
                
                switch name {
                case "Sol":
                    SunVisual()
                case "Lua":
                    MoonVisual()
                case "Mercúrio":
                    MercuryVisual()
                case "Vênus":
                    VenusVisual()
                case "Marte":
                    MarsVisual()
                case "Júpiter":
                    JupiterVisual()
                case "Saturno":
                    SaturnVisual()
                case "Urano":
                    UranusVisual()
                case "Netuno":
                    NeptuneVisual()
                case "Plutão":
                    PlutoVisual()
                default:
                    Color.gray.opacity(0.5)
                }
            }
        }
    }
}

struct SunVisual: View {
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Color(hex: "FFD700").opacity(0.8), Color(hex: "FF8C00").opacity(0.6), Color.clear],
                center: .center,
                startRadius: 0,
                endRadius: 100
            )
            
            // Rays
            ForEach(0..<12) { i in
                Rectangle()
                    .fill(Color(hex: "FFD700").opacity(0.3))
                    .frame(width: 4, height: 200)
                    .rotationEffect(.degrees(Double(i) * 30))
            }
            .rotationEffect(.degrees(15))
        }
    }
}

struct MoonVisual: View {
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Color(hex: "F0F0F0").opacity(0.8), Color(hex: "A9A9A9").opacity(0.6), Color.clear],
                center: .topLeading,
                startRadius: 10,
                endRadius: 150
            )
            
            // Craters
            Circle()
                .fill(Color.black.opacity(0.2))
                .frame(width: 30, height: 30)
                .offset(x: -30, y: -20)
            
            Circle()
                .fill(Color.black.opacity(0.25))
                .frame(width: 20, height: 20)
                .offset(x: 40, y: 30)
            
            Circle()
                .fill(Color.black.opacity(0.1))
                .frame(width: 50, height: 50)
                .offset(x: 20, y: -40)
        }
    }
}

struct MercuryVisual: View {
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Color(hex: "A9A9A9").opacity(0.8), Color(hex: "696969").opacity(0.6), Color.clear],
                center: .center,
                startRadius: 0,
                endRadius: 100
            )
            
            // Metallic texture lines
            Path { path in
                path.move(to: CGPoint(x: 0, y: 160))
                path.addCurve(to: CGPoint(x: 160, y: 0), control1: CGPoint(x: 50, y: 100), control2: CGPoint(x: 100, y: 50))
            }
            .stroke(Color.white.opacity(0.2), lineWidth: 2)
        }
    }
}

struct VenusVisual: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "FFDEAD").opacity(0.8), Color(hex: "FFA07A").opacity(0.6), Color.clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Hazy clouds
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 100, height: 100)
                .blur(radius: 20)
                .offset(x: -30, y: -30)
        }
    }
}

struct MarsVisual: View {
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Color(hex: "FF4500").opacity(0.8), Color(hex: "8B0000").opacity(0.6), Color.clear],
                center: .center,
                startRadius: 0,
                endRadius: 120
            )
            
            // Dusty patches
            Circle()
                .fill(Color.black.opacity(0.3))
                .frame(width: 60, height: 40)
                .blur(radius: 10)
                .offset(x: 30, y: 20)
        }
    }
}

struct JupiterVisual: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "F5DEB3").opacity(0.8),
                    Color(hex: "CD853F").opacity(0.7),
                    Color(hex: "8B4513").opacity(0.6),
                    Color(hex: "CD853F").opacity(0.7),
                    Color(hex: "F5DEB3").opacity(0.8)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .rotationEffect(.degrees(-20))
            .scaleEffect(1.5)
            
            // Great Red Spot
            Ellipse()
                .fill(Color(hex: "8B0000").opacity(0.6))
                .frame(width: 50, height: 30)
                .offset(x: 20, y: 20)
                .blur(radius: 5)
        }
    }
}

struct SaturnVisual: View {
    var body: some View {
        ZStack {
            // Planet body
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "F4C430").opacity(0.9), Color(hex: "DAA520").opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 80, height: 80)
            
            // Rings
            Ellipse()
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "D2B48C").opacity(0.8), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 15
                )
                .frame(width: 140, height: 60)
                .rotationEffect(.degrees(-20))
        }
    }
}

struct UranusVisual: View {
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Color(hex: "E0FFFF").opacity(0.8), Color(hex: "00CED1").opacity(0.6), Color.clear],
                center: .center,
                startRadius: 0,
                endRadius: 100
            )
            
            // Vertical ring hint
            Ellipse()
                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                .frame(width: 40, height: 140)
                .rotationEffect(.degrees(10))
        }
    }
}

struct NeptuneVisual: View {
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Color(hex: "1E90FF").opacity(0.8), Color(hex: "00008B").opacity(0.6), Color.clear],
                center: .center,
                startRadius: 0,
                endRadius: 120
            )
            
            // Stormy clouds
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 80, height: 60)
                .blur(radius: 15)
                .offset(x: -20, y: -20)
        }
    }
}

struct PlutoVisual: View {
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Color(hex: "D8BFD8").opacity(0.8), Color(hex: "4B0082").opacity(0.6), Color.clear],
                center: .topTrailing,
                startRadius: 0,
                endRadius: 100
            )
            
            // Icy surface
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 40, height: 40)
                .blur(radius: 5)
                .offset(x: 30, y: 30)
        }
    }
}

#Preview {
    AstrologyListView()
        .modelContainer(for: PlanetEntity.self, inMemory: true)
}
