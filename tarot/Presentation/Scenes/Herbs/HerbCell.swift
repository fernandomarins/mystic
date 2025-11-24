//
//  HerbCell.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import SwiftUI

struct HerbCell: View {
    let herb: Herb
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1C1C1E"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isSelected ? Color.purple : Color.white.opacity(0.1),
                            lineWidth: isSelected ? 2 : 1
                        )
                )
                .shadow(color: isSelected ? .purple.opacity(0.5) : .black.opacity(0.3), radius: 4, x: 0, y: 2)
            
            VStack(spacing: 12) {
                // Icon
                Image(systemName: "leaf.fill") // Placeholder icon
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .foregroundColor(typeColor)
                    .padding(.top, 16)
                
                VStack(spacing: 4) {
                    // Name
                    Text(herb.name)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
            }
        }
        .frame(height: 140)
    }
    
    private var typeColor: Color {
        switch herb.type {
        case .hot: return .red
        case .warm: return .yellow
        case .cold: return .blue
        }
    }
}

#Preview {
    ZStack {
        Color.black
        HStack {
            HerbCell(
                herb: .init(name: "Alecrim", scientificName: "Rosmarinus officinalis", type: .hot, description: ""),
                isSelected: false
            )
            HerbCell(
                herb: .init(name: "Lavanda", scientificName: "Lavandula", type: .cold, description: ""),
                isSelected: true
            )
        }
        .padding()
    }
}
