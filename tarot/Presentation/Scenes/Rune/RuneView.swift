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
    
    private var sectionColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Hero Section
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [Color.cyan.opacity(0.2), Color.clear]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 150
                                )
                            )
                            .frame(height: 300)
                        
                        Image(uiImage: UIImage(named: rune.name) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                            .shadow(color: .cyan.opacity(0.8), radius: 20, x: 0, y: 0)
                    }
                    .padding(.top, 20)
                    
                    // Title
                    Text(rune.name)
                        .font(.system(size: 40, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .shadow(color: .cyan.opacity(0.5), radius: 10)
                    
                    // Attributes Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        AttributeCell(title: "Árvore", value: rune.tree, icon: "leaf.fill")
                        AttributeCell(title: "Cor", value: rune.color, icon: "paintpalette.fill")
                        AttributeCell(title: "Pedra", value: rune.rock, icon: "hexagon.fill")
                        AttributeCell(title: "Magia", value: rune.magic, icon: "sparkles")
                    }
                    .padding(.horizontal)
                    
                    // Power/Meaning Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Poder & Significado")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.cyan)
                        
                        Text(rune.power)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(6)
                    }
                    .padding()
                    .background(Color(hex: "1C1C1E"))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
        }
    }
}

struct AttributeCell: View {
    let title: String
    let value: String?
    let icon: String
    
    var body: some View {
        if let value = value, !value.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.cyan)
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text(value)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "1C1C1E"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

#Preview {
    RuneView(rune: .init(id: 0, name: "", power: "", magic: "", tree: "", rock: "", color: ""))
}
