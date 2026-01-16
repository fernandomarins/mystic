//
//  MainView.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import SwiftUI

struct MainView: View {
    private let sections: [Main] = [
        .init(id: 0, name: .tarot),
        .init(id: 1, name: .runes),
        .init(id: 2, name: .daemons),
        .init(id: 3, name: .herbs),
        .init(id: 4, name: .astrology),
        .init(id: 5, name: .bones),
        .init(id: 6, name: .cabala),
        .init(id: 7, name: .banimento),
        .init(id: 8, name: .talisma),
        .init(id: 9, name: .pontosRiscados),
        .init(id: 10, name: .dadomancia),
        .init(id: 11, name: .geomancia)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Cosmic background
                LinearGradient(
                    colors: [Color(hex: "0A0015"), Color(hex: "1A0033"), Color.black],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Animated stars
                GeometryReader { geometry in
                    ForEach(0..<100, id: \.self) { index in
                        Circle()
                            .fill(Color.white.opacity(Double.random(in: 0.2...0.9)))
                            .frame(width: CGFloat.random(in: 1...3))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .blur(radius: CGFloat.random(in: 0...1))
                    }
                }
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Mystical Header
                        VStack(spacing: 12) {
                            // Mystical symbol
                            Text("✦")
                                .font(.system(size: 40))
                                .foregroundColor(.purple.opacity(0.8))
                                .shadow(color: .purple, radius: 10, x: 0, y: 0)
                            
                            Text("Grimório")
                                .font(.system(size: 42, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                                .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 0)
                        }
                        .padding(.top, 40)
                        
                        // Mystical Grid
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 20
                        ) {
                            ForEach(sections) { section in
                                NavigationLink(destination: destinationView(for: section)) {
                                    MysticalFeatureCell(section: section)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Footer symbol
                        Text("✧")
                            .font(.system(size: 24))
                            .foregroundColor(.purple.opacity(0.5))
                            .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    private func destinationView(for section: Main) -> some View {
        switch section.name {
        case .tarot:
            CardListView()
        case .runes:
            RuneListView()
        case .daemons:
            DaemonListView()
        case .bones:
            SangomaView()
        case .astrology:
            AstrologyListView()
        case .herbs:
            HerbsListView()
        case .hoodoo:
            HoodooListView()
        case .cabala:
            CabalaView()
        case .banimento:
            BanimentoView()
        case .talisma:
            TalismaView()
        case .pontosRiscados:
            PontosRiscadosView()
        case .dadomancia:
            DadomanciaView()
        case .geomancia:
            GeomanciaView()
        }
    }
}

struct MysticalFeatureCell: View {
    let section: Main
    @State private var isGlowing = false
    
    var body: some View {
        ZStack {
            // Outer glow
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    RadialGradient(
                        colors: [
                            gradientColors(for: section.name).first?.opacity(0.4) ?? .clear,
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .blur(radius: 20)
                .opacity(isGlowing ? 0.8 : 0.4)
            
            // Card Background
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors(for: section.name)),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.5), .white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: gradientColors(for: section.name).first?.opacity(0.5) ?? .clear, radius: 15, x: 0, y: 8)
            
            // Content
            VStack(spacing: 16) {
                // Icon with glow
                ZStack {
                    // Icon glow
                    Image(uiImage: UIImage(named: section.name.rawValue) ?? UIImage())
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 65)
                        .foregroundColor(.white)
                        .blur(radius: 8)
                        .opacity(0.6)
                    
                    // Icon
                    Image(uiImage: UIImage(named: section.name.rawValue) ?? UIImage())
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 65)
                        .foregroundColor(.white)
                }
                
                // Title
                Text(section.name.rawValue)
                    .font(.system(.title3, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                
                // Mystical divider
                HStack(spacing: 4) {
                    Text("✦")
                        .font(.system(size: 8))
                        .foregroundColor(.white.opacity(0.6))
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 30, height: 1)
                    Text("✦")
                        .font(.system(size: 8))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding()
        }
        .frame(height: 180)
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 2)
                    .repeatForever(autoreverses: true)
            ) {
                isGlowing = true
            }
        }
    }
    
    private func gradientColors(for name: SectionName) -> [Color] {
        switch name {
        case .tarot: return [Color(hex: "5D3FD3"), Color(hex: "1F005C")] // Iris to Dark Indigo
        case .runes: return [Color(hex: "9B30FF"), Color(hex: "2A0045")] // Purple to Dark Violet
        case .daemons: return [Color(hex: "4B0082"), Color(hex: "150030")] // Indigo to Dark
        case .bones: return [Color(hex: "8A2BE2"), Color(hex: "200040")] // Blue Violet to Dark
        case .astrology: return [Color(hex: "BA55D3"), Color(hex: "38004D")] // Medium Orchid to Dark
        case .herbs: return [Color(hex: "7B68EE"), Color(hex: "1C0045")] // Medium Slate Blue to Dark
        case .hoodoo: return [Color(hex: "6A5ACD"), Color(hex: "18003D")] // Slate Blue to Dark
        case .cabala: return [Color(hex: "6A5ACD"), Color(hex: "18003D")] // Gold to Midnight Blue
        case .banimento: return [Color(hex: "8B0000"), Color(hex: "2A0000")] // Dark Red to Darker Red
        case .talisma: return [Color(hex: "9D4EDD"), Color(hex: "3C096C")] // Purple to Dark Purple
        case .pontosRiscados: return [Color(hex: "1B4332"), Color(hex: "081C15")] // Forest Green to Darker Green
        case .dadomancia: return [Color(hex: "5D3FD3"), Color(hex: "1A0033")] // Iris to Dark Deep Blue
        case .geomancia: return [Color(hex: "8B4513"), Color(hex: "3D2B1F")] // Saddle Brown to Earthy
        }
    }
}

#Preview {
    MainView()
}
