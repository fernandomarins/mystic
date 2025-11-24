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
        ZStack {
            // Hell Background
            LinearGradient(
                colors: [Color(hex: "2A0000"), Color(hex: "1A0000"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Fire particles overlay
            GeometryReader { geometry in
                ForEach(0..<30, id: \.self) { _ in
                    Circle()
                        .fill(Color(hex: "FF4500").opacity(Double.random(in: 0.1...0.25)))
                        .frame(width: CGFloat.random(in: 2...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero Section
                    ZStack {
                        // Hellish Glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [Color(hex: "FF3300").opacity(0.3), Color.clear]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 180
                                )
                            )
                            .frame(height: 350)
                            .blur(radius: 20)
                        
                        // Pentagram/Circle Background
                        Circle()
                            .strokeBorder(
                                AngularGradient(
                                    gradient: Gradient(colors: [.red.opacity(0.5), .clear, .red.opacity(0.5)]),
                                    center: .center
                                ),
                                lineWidth: 2
                            )
                            .frame(width: 280, height: 280)
                            .rotationEffect(.degrees(180))
                        
                        // Daemon Image/Sigil
                        Image(daemon.name)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color(hex: "FF4500"))
                            .scaledToFit()
                            .frame(height: 200)
                            .shadow(color: .red.opacity(0.8), radius: 25, x: 0, y: 0)
                        
                        // White core for intensity
                        Image(daemon.name)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white.opacity(0.8))
                            .scaledToFit()
                            .frame(height: 200)
                            .blendMode(.overlay)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                    // Title
                    VStack(spacing: 8) {
                        Text(daemon.name)
                            .font(.system(size: 48, weight: .bold, design: .serif))
                            .foregroundColor(Color(hex: "FFE5B4"))
                            .shadow(color: .red.opacity(0.6), radius: 15)
                        
                        Text("#\(daemon.id)")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(.red.opacity(0.7))
                        
                        // Decorative divider
                        HStack(spacing: 10) {
                            Rectangle()
                                .fill(LinearGradient(colors: [.clear, .red.opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                                .frame(width: 60, height: 1)
                            Text("⛧")
                                .font(.system(size: 20))
                                .foregroundColor(.red.opacity(0.8))
                            Rectangle()
                                .fill(LinearGradient(colors: [.red.opacity(0.6), .clear], startPoint: .leading, endPoint: .trailing))
                                .frame(width: 60, height: 1)
                        }
                    }
                    .padding(.bottom, 40)
                    
                    // Enn (Chant)
                    if !daemon.enn.isEmpty {
                        Text("\"\(daemon.enn)\"")
                            .font(.system(size: 22, weight: .medium, design: .serif))
                            .italic()
                            .foregroundColor(Color(hex: "FFD700")) // Gold
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 40)
                            .shadow(color: .orange.opacity(0.3), radius: 5)
                    }
                    
                    // Attributes Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        HellAttributeCell(title: "Planeta", value: daemon.planet, icon: "globe")
                        HellAttributeCell(title: "Direção", value: daemon.direction, icon: "location.north.circle")
                        HellAttributeCell(title: "Pathworking", value: daemon.pathworking, icon: "map")
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    
                    // Description Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.red)
                            Text("Descrição")
                                .font(.title2)
                                .bold()
                                .foregroundColor(Color(hex: "FFE5B4"))
                        }
                        
                        Text(daemon.description)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(8)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(hex: "1A0505").opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                    
                    // Houses Detail (if available)
                    if let houses = daemon.houses, !houses.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "house.fill")
                                    .foregroundColor(.red)
                                Text("Casas Astrológicas")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(Color(hex: "FFE5B4"))
                            }
                            
                            ForEach(houses, id: \.self) { house in
                                HStack(alignment: .top) {
                                    Text("•")
                                        .foregroundColor(.red)
                                    Text(house)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color(hex: "1A0505").opacity(0.8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 60)
                }
            }
        }
    }
}

struct HellAttributeCell: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.red)
                    .font(.system(size: 16))
                Text(title)
                    .font(.caption)
                    .textCase(.uppercase)
                    .foregroundColor(.gray)
                    .tracking(1)
            }
            
            Text(value)
                .font(.system(.body, design: .serif))
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "FFE5B4"))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1A0505").opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.red.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    DaemonView(daemon: .init(id: 1, name: "Baal", enn: "Ayer Secore On Ca Ba al", description: "", planet: "Sol", direction: "Sul", pathworking: "", houses: nil))
}
