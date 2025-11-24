//
//  DaemonView.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import SwiftUI

struct DaemonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let daemon: DaemonModel
    
    private var sectionColor: Color {
        Color.primary
    }
    
    private func daemonSection(
        title: String,
        content: String?,
        contents: [String]?
    ) -> some View {
        Group {
            if let contents {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title2)
                        .bold()
                    ForEach(contents, id: \.self) { house in
                        let parts = house.split(separator: ":", maxSplits: 1)
                        if parts.count == 2 {
                            Text("\(parts[0]):")
                                .fontWeight(.bold) +
                            Text("\(parts[1])")
                        } else {
                            Text(house)
                        }
                    }
                    Divider()
                        .background(sectionColor)
                }
            }
            if let content = content, !content.isEmpty {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title2)
                        .bold()
                    Text(content)
                    Divider()
                        .background(sectionColor)
                }
            }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Hero Image Section
                ZStack(alignment: .bottom) {
                    // Image Background
                    Rectangle()
                        .fill(Color(hex: "1C1C1E"))
                        .frame(height: 350)
                    
                    Image(daemon.name) // Assuming asset name matches daemon name
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(height: 280)
                        .shadow(color: .purple.opacity(0.6), radius: 10, x: 0, y: 0)
                        .padding(.bottom, 40)
                    
                    // Gradient fade at bottom
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, Color.black]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                    
                    // Title Overlay
                    VStack(spacing: 4) {
                        Text(daemon.name)
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .shadow(color: .purple.opacity(0.5), radius: 4, x: 0, y: 2)
                        
                        Text("#\(daemon.id)")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 20)
                }
                
                // Content Section
                VStack(alignment: .leading, spacing: 24) {
                    // Enn (Chant)
                    if !daemon.enn.isEmpty {
                        Text("\"\(daemon.enn)\"")
                            .font(.system(size: 20, weight: .medium, design: .serif))
                            .italic()
                            .foregroundColor(Color(hex: "D4AF37")) // Gold
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.05))
                            )
                    }
                    
                    // Attributes Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        AttributeCell(title: "Planeta", value: daemon.planet, icon: "globe")
                        AttributeCell(title: "Direção", value: daemon.direction, icon: "location.north.circle")
                        AttributeCell(title: "Pathworking", value: daemon.pathworking, icon: "map")
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "book.closed")
                                .foregroundColor(.purple)
                            Text("Descrição")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                        }
                        
                        Text(daemon.description)
                            .font(.body)
                            .foregroundColor(.gray)
                            .lineSpacing(4)
                    }
                    
                    // Houses Detail (if available)
                    if let houses = daemon.houses, !houses.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "house.fill")
                                    .foregroundColor(.purple)
                                Text("Casas Astrológicas")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            
                            ForEach(houses, id: \.self) { house in
                                Text("• \(house)")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.black)
    }
}

#Preview {
    DaemonView(daemon: .init(id: 1, name: "Baal", enn: "Ayer Secore On Ca Ba al", description: "", planet: "Sol", direction: "Sul", pathworking: "", houses: nil))
}
