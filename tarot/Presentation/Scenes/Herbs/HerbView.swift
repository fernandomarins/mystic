//
//  HerbView.swift
//  tarot
//
//  Created by Fernando Marins on 28/09/24.
//

import SwiftUI

struct HerbView: View {
    let herb: Herb
    
    var body: some View {
        ZStack {
            // Forest Background
            LinearGradient(
                colors: [Color(hex: "051A05"), Color(hex: "0A200A"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Fireflies/Magic particles overlay
            GeometryReader { geometry in
                ForEach(0..<30, id: \.self) { _ in
                    Circle()
                        .fill(Color(hex: "CCFF00").opacity(Double.random(in: 0.1...0.25)))
                        .frame(width: CGFloat.random(in: 2...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .shadow(color: .green, radius: 3)
                }
            }
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero Section
                    ZStack {
                        // Magical Glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [typeColor.opacity(0.3), Color.clear]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 150
                                )
                            )
                            .frame(height: 300)
                            .blur(radius: 20)
                        
                        // Nature Circle Background
                        Circle()
                            .strokeBorder(
                                AngularGradient(
                                    gradient: Gradient(colors: [Color(hex: "228B22").opacity(0.5), .clear, Color(hex: "228B22").opacity(0.5)]),
                                    center: .center
                                ),
                                lineWidth: 2
                            )
                            .frame(width: 250, height: 250)
                            .rotationEffect(.degrees(30))
                        
                        // Herb Icon/Image
                        Image(systemName: "leaf.fill") // Placeholder
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                            .foregroundColor(typeColor)
                            .shadow(color: typeColor.opacity(0.8), radius: 20, x: 0, y: 0)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                    // Title Section
                    VStack(spacing: 8) {
                        Text(herb.name)
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(Color(hex: "F0FFF0")) // Honeydew
                            .shadow(color: .green.opacity(0.6), radius: 10)
                        
                        Text(herb.scientificName)
                            .font(.system(size: 20, design: .serif))
                            .italic()
                            .foregroundColor(Color(hex: "8FBC8F")) // Dark Sea Green
                        
                        // Decorative divider
                        HStack(spacing: 10) {
                            Rectangle()
                                .fill(LinearGradient(colors: [.clear, Color(hex: "228B22").opacity(0.6)], startPoint: .leading, endPoint: .trailing))
                                .frame(width: 60, height: 1)
                            Image(systemName: "leaf")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "228B22").opacity(0.8))
                            Rectangle()
                                .fill(LinearGradient(colors: [Color(hex: "228B22").opacity(0.6), .clear], startPoint: .leading, endPoint: .trailing))
                                .frame(width: 60, height: 1)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 40)
                    
                    // Attributes Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForestAttributeCell(
                            title: "Tipo",
                            value: herb.type.rawValue,
                            icon: "flame.fill",
                            accentColor: typeColor
                        )
                        
                        ForestAttributeCell(
                            title: "Nome Científico",
                            value: herb.scientificName,
                            icon: "text.book.closed.fill",
                            accentColor: .green
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    
                    // Description Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "book.closed.fill")
                                .foregroundColor(Color(hex: "228B22"))
                            Text("Propriedades & Usos")
                                .font(.title2)
                                .bold()
                                .foregroundColor(Color(hex: "F0FFF0"))
                        }
                        
                        Text(herb.description)
                            .font(.body)
                            .foregroundColor(Color(hex: "F0FFF0").opacity(0.9))
                            .lineSpacing(8)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(hex: "1A2F1A").opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color(hex: "228B22").opacity(0.3), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 60)
                }
            }
        }
    }
    
    private var typeColor: Color {
        switch herb.type {
        case .hot: return .red
        case .warm: return .yellow
        case .cold: return .cyan
        }
    }
}

struct ForestAttributeCell: View {
    let title: String
    let value: String
    let icon: String
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(accentColor)
                    .font(.system(size: 16))
                Text(title)
                    .font(.caption)
                    .textCase(.uppercase)
                    .foregroundColor(Color(hex: "8FBC8F"))
                    .tracking(1)
            }
            
            Text(value)
                .font(.system(.body, design: .serif))
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "F0FFF0"))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1A2F1A").opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "228B22").opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    HerbView(herb: .init(name: "Lavender", scientificName: "Lavandula angustifolia", type: .cold, description: "Lavender is known for its relaxing and calming effects."))
}
