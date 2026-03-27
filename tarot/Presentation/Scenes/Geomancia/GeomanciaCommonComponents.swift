//
//  GeomanciaCommonComponents.swift
//  tarot
//
//  Created by Antigravity on 16/01/26.
//

import SwiftUI

// MARK: - Components

struct BadgeView: View {
    let text: String
    let icon: String
    let color: Color
    
    var body: some View {
        Label(text, systemImage: icon)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Capsule().fill(.white.opacity(0.05)))
            .overlay(Capsule().stroke(color.opacity(0.2), lineWidth: 0.5))
    }
}

struct GeomanticSymbolView: View {
    let pattern: [Int]
    let color: Color
    var dotSize: CGFloat = 10
    var spacing: CGFloat = 12
    
    private var rowWidth: CGFloat {
        dotSize * 2 + spacing
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<4) { index in
                HStack(spacing: spacing) {
                    if index < pattern.count {
                        if pattern[index] == 1 {
                            dot
                        } else {
                            dot
                            dot
                        }
                    }
                }
                .frame(width: rowWidth) // Fixed width ensures single dot is centered at the same axis as the gap of double dots
            }
        }
    }
    
    private var dot: some View {
        Circle()
            .fill(color)
            .frame(width: dotSize, height: dotSize)
            .shadow(color: color.opacity(0.5), radius: 2)
    }
}

// MARK: - Secondary Views

struct GeomanciaDetailView: View {
    let item: GeomanciaMeaning
    @Environment(\.dismiss) var dismiss
    
    private let accentGold = Color(hex: "D4AF37")
    
    var body: some View {
        ZStack {
            // Background - Consistent with Reading View
            LinearGradient(
                colors: [Color(hex: "1B1212"), Color(hex: "2D1B10")],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            // Decorative background symbol
            VStack {
                Spacer()
                Image(systemName: "circle.grid.cross.fill")
                    .foregroundColor(accentGold.opacity(0.03))
                    .font(.system(size: 400))
                    .offset(y: 200)
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Pull indicator
                    Capsule()
                        .fill(.white.opacity(0.2))
                        .frame(width: 36, height: 5)
                        .padding(.top, 12)
                    
                    // Main Container
                    VStack(spacing: 0) {
                        // Header Section
                        VStack(spacing: 25) {
                            GeomanticSymbolView(pattern: item.pattern, color: accentGold, dotSize: 15, spacing: 20)
                                .padding(30)
                                .background(
                                    Circle()
                                        .fill(accentGold.opacity(0.05))
                                        .overlay(Circle().stroke(accentGold.opacity(0.2), lineWidth: 1))
                                )
                                .shadow(color: accentGold.opacity(0.3), radius: 20)
                            
                            VStack(spacing: 8) {
                                Text(item.name)
                                    .font(.system(size: 34, weight: .bold, design: .serif))
                                    .foregroundColor(.white)
                                
                                if let otherNames = item.otherNames {
                                    Text(otherNames)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(.white.opacity(0.4))
                                        .italic()
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                        .padding(.bottom, 10)
                                } else {
                                    Spacer().frame(height: 10)
                                }
                                
                                HStack(spacing: 8) {
                                    if let planet = item.planet {
                                        BadgeView(text: planet, icon: "sparkles", color: .white.opacity(0.6))
                                    }
                                    if let zodiac = item.zodiac {
                                        BadgeView(text: zodiac, icon: "star.fill", color: .white.opacity(0.6))
                                    }
                                }
                                
                                HStack(spacing: 8) {
                                    BadgeView(text: item.parity, icon: "equal.circle", color: .white.opacity(0.6))
                                    BadgeView(text: item.period, icon: item.period == "Diurna" ? "sun.max.fill" : "moon.fill", color: .white.opacity(0.6))
                                }
                                
                                HStack(spacing: 8) {
                                    BadgeView(text: item.element, icon: "drop.fill", color: accentGold.opacity(0.8))
                                    BadgeView(text: item.nature, icon: "scope", color: accentGold.opacity(0.8))
                                    if let quality = item.quality {
                                        BadgeView(text: quality, icon: "pencil.and.outline", color: accentGold.opacity(0.8))
                                    }
                                }
                                .padding(.top, 5)
                            }
                        }
                        .padding(.vertical, 40)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.02))
                        
                        // Body Content
                        VStack(spacing: 35) {
                            // 1. Essence Keyword
                            if let keyword = item.keyword {
                                VStack(spacing: 8) {
                                    Text("ESSÊNCIA")
                                        .font(.system(size: 10, weight: .black))
                                        .foregroundColor(accentGold.opacity(0.5))
                                        .tracking(2)
                                    Text(keyword.uppercased())
                                        .font(.system(size: 26, weight: .bold, design: .serif))
                                        .foregroundColor(accentGold)
                                }
                            }
                            
                            // 2. Correspondences (MOVED UP)
                            VStack(alignment: .leading, spacing: 15) {
                                Text("CORRESPONDÊNCIAS")
                                    .font(.system(size: 12, weight: .black))
                                    .foregroundColor(accentGold.opacity(0.5))
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                    if let anatomy = item.anatomy {
                                        miniInfoCell(title: "Anatomia", text: anatomy, icon: "figure.human")
                                    }
                                    if let color = item.color {
                                        miniInfoCell(title: "Cor", text: color, icon: "paintpalette")
                                    }
                                    if let outer = item.outerElement {
                                        miniInfoCell(title: "Elemen. Ext.", text: outer, icon: "sparkles")
                                    }
                                    if let inner = item.innerElement {
                                        miniInfoCell(title: "Elemen. Int.", text: inner, icon: "bolt.fill")
                                    }
                                }
                            }

                            // 3. Prognosis (MOVED UP AND RENAMED)
                            VStack(spacing: 12) {
                                Text("PROGNÓSTICO")
                                    .font(.system(size: 12, weight: .black))
                                    .foregroundColor(accentGold.opacity(0.5))
                                    .tracking(2)
                                
                                Text(item.answer)
                                    .font(.system(size: 28, weight: .black, design: .serif))
                                    .foregroundColor(accentGold)
                                    .shadow(color: accentGold.opacity(0.5), radius: 10)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 20).fill(accentGold.opacity(0.05)))

                            // 4. House Relationships
                            if (item.strengthenedHouses?.isEmpty == false) || (item.weakenedHouses?.isEmpty == false) {
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("DIGNIDADES (NAS CASAS)")
                                        .font(.system(size: 12, weight: .black))
                                        .foregroundColor(accentGold.opacity(0.5))
                                    
                                    HStack(spacing: 12) {
                                        if let strengthened = item.strengthenedHouses, !strengthened.isEmpty {
                                            HStack {
                                                Image(systemName: "crown.fill").foregroundColor(.yellow)
                                                Text("Fortalecida:").font(.system(size: 13, weight: .bold))
                                                Text(strengthened.map { "\($0)" }.joined(separator: ", "))
                                                    .font(.system(size: 13))
                                                Spacer()
                                            }
                                            .padding(12)
                                            .background(Color.yellow.opacity(0.1))
                                            .cornerRadius(12)
                                            .frame(maxWidth: .infinity)
                                        }
                                        
                                        if let weakened = item.weakenedHouses, !weakened.isEmpty {
                                            HStack {
                                                Image(systemName: "arrow.down.circle.fill").foregroundColor(.red)
                                                Text("Enfraquecida:").font(.system(size: 13, weight: .bold))
                                                Text(weakened.map { "\($0)" }.joined(separator: ", "))
                                                    .font(.system(size: 13))
                                                Spacer()
                                            }
                                            .padding(12)
                                            .background(Color.red.opacity(0.1))
                                            .cornerRadius(12)
                                            .frame(maxWidth: .infinity)
                                        }
                                    }
                                }
                            }

                            // 5. Traditional Meanings
                            VStack(alignment: .leading, spacing: 25) {
                                detailSection(title: "SENTIDO TRADICIONAL", text: item.meaning)

                                if let images = item.images {
                                    detailSection(title: "SÍMBOLO VISUAL", text: images)
                                }
                                
                                if let divMeaning = item.divinatoryMeaning {
                                    detailSection(title: "SIGNIFICADO DIVINATÓRIO", text: divMeaning)
                                }
                            }

                            // 6. Physical & Character
                            VStack(alignment: .leading, spacing: 25) {
                                if let body = item.bodyType {
                                    detailSection(title: "TIPO FÍSICO / APARÊNCIA", text: body)
                                }
                                if let character = item.characterType {
                                    detailSection(title: "TEMPERAMENTO / CARÁTER", text: character)
                                }
                            }

                            // 7. Esoteric Commentary
                            if let commentary = item.commentary {
                                detailSection(title: "COMENTÁRIO ESOTÉRICO", text: commentary)
                            }
                        }
                        .padding(30)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 32)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(accentGold.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 25)
                    
                    // Close button
                    Button(action: { dismiss() }) {
                        Text("Fechar Detalhes")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .height(56)
                            .background(RoundedRectangle(cornerRadius: 16).fill(accentGold))
                            .shadow(color: accentGold.opacity(0.4), radius: 10)
                    }
                    .padding(.horizontal, 50)
                    .padding(.bottom, 50)
                    .padding(.top, 10)
                }
            }
        }
    }

    // MARK: - Helper Subviews
    
    private func detailSection(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 12, weight: .black))
                .foregroundColor(accentGold.opacity(0.5))
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func miniInfoCell(title: String, text: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(accentGold)
                .frame(width: 32, height: 32)
                .background(Circle().fill(accentGold.opacity(0.1)))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white.opacity(0.4))
                Text(text)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.04)))
    }
}
