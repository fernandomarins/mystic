//
//  SangomaCell.swift
//  tarot
//
//  Created by Fernando Marins on 24/11/24.
//

import SwiftUI

struct SangomaCell: View {
    let title: String
    let description: String
    let type: SangomaType
    
    enum SangomaType {
        case bone
        case buzio
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon Container
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "3E2723"), Color(hex: "1B0000")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(Color(hex: "8D6E63").opacity(0.5), lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(hex: "D7CCC8")) // Bone white
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(.title3, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "EFEBE9"))
                
                Text(description)
                    .font(.system(.body, design: .serif))
                    .foregroundColor(Color(hex: "BCAAA4"))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "2D1B18").opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [Color(hex: "5D4037").opacity(0.5), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
    }
    
    private var iconName: String {
        switch type {
        case .bone: return "circle.grid.cross.fill" // Abstract bone/structure representation
        case .buzio: return "oval.portrait.fill" // Shell-like shape
        }
    }
}

#Preview {
    ZStack {
        Color.black
        VStack {
            SangomaCell(
                title: "Osso da Hiena",
                description: "Representa o riso diante da morte e a sobrevivência.",
                type: .bone
            )
            SangomaCell(
                title: "Búzio Aberto",
                description: "Caminhos abertos, luz e clareza espiritual.",
                type: .buzio
            )
        }
        .padding()
    }
}
