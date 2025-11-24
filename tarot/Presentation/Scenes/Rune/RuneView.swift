//
//  RuneView.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct RuneView: View {
    @Environment(\.colorScheme) private var colorScheme

    let rune: RuneModel
    
    var body: some View {
        ZStack {
            // Nordic Background
            LinearGradient(
                colors: [Color(hex: "1A2332"), Color(hex: "0F141E"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Snow/Ash particles overlay
            GeometryReader { geometry in
                ForEach(0..<30, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.1...0.25)))
                        .frame(width: CGFloat.random(in: 1...2))
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
                        // Mystical Glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [Color.cyan.opacity(0.3), Color.clear]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 180
                                )
                            )
                            .frame(height: 350)
                            .blur(radius: 20)
                        
                        // Runic Circle Background
                        Circle()
                            .strokeBorder(
                                AngularGradient(
                                    gradient: Gradient(colors: [.cyan.opacity(0.5), .clear, .cyan.opacity(0.5)]),
                                    center: .center
                                ),
                                lineWidth: 2
                            )
                            .frame(width: 280, height: 280)
                            .rotationEffect(.degrees(45))
                        
                        // Rune Image
                        Image(uiImage: UIImage(named: rune.name) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .shadow(color: .cyan.opacity(0.8), radius: 25, x: 0, y: 0)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                    // Title
                    VStack(spacing: 8) {
                        Text(rune.name)
                            .font(.system(size: 48, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .shadow(color: .cyan.opacity(0.6), radius: 15)
                        
                        // Decorative divider
                        HStack(spacing: 10) {
                            Rectangle()
                                .fill(LinearGradient(colors: [.clear, .cyan.opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                                .frame(width: 60, height: 1)
                            Text("ᛟ") // Othala rune
                                .font(.system(size: 20))
                                .foregroundColor(.cyan.opacity(0.8))
                            Rectangle()
                                .fill(LinearGradient(colors: [.cyan.opacity(0.6), .clear], startPoint: .leading, endPoint: .trailing))
                                .frame(width: 60, height: 1)
                        }
                    }
                    .padding(.bottom, 40)
                    
                    // Attributes Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        if let tree = rune.tree {
                            NordicAttributeCell(title: "Árvore", value: tree, icon: "leaf.fill")
                        }
                        if let color = rune.color {
                            NordicAttributeCell(title: "Cor", value: color, icon: "paintpalette.fill")
                        }
                        if let magic = rune.magic {
                            NordicAttributeCell(title: "Magia", value: magic, icon: "sparkles")
                        }
                        if let rock = rune.rock {
                            NordicAttributeCell(title: "Pedra", value: rock, icon: "hexagon.fill")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    
                    // Power/Meaning Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(.cyan)
                            Text("Poder & Significado")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                        }
                        
                        Text(rune.power)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(8)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(hex: "1C2833").opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.cyan.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 60)
                }
            }
        }
    }
}

struct NordicAttributeCell: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.cyan)
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
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1C2833").opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    RuneView(rune: .init(id: 0, name: "Fehu", power: "Riqueza e Abundância", magic: "Prosperidade", tree: "Sabugueiro", rock: "Musgo", color: "Vermelho"))
}
