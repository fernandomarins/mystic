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
        .init(id: 3, name: .bones),

        .init(id: 5, name: .astrology),
        .init(id: 6, name: .herbs),
        .init(id: 7, name: .hoodoo)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Grimório")
                                .font(.system(size: 32, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                            Text("Escolha seu caminho")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 20)
                        
                        // Grid
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 16
                        ) {
                            ForEach(sections) { section in
                                NavigationLink(destination: destinationView(for: section)) {
                                    FeatureCell(section: section)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
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
        }
    }
}

struct FeatureCell: View {
    let section: Main
    
    var body: some View {
        ZStack {
            // Card Background
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors(for: section.name)),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: gradientColors(for: section.name).first?.opacity(0.3) ?? .clear, radius: 8, x: 0, y: 4)
            
            VStack(spacing: 16) {
                // Icon
                Image(uiImage: UIImage(named: section.name.rawValue) ?? UIImage())
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                
                // Title
                Text(section.name.rawValue)
                    .font(.system(.headline, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .frame(height: 160)
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
        }
    }
}

#Preview {
    MainView()
}
