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
            // Forest Card Background
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "1A2F1A"), Color(hex: "0F1F0F")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isSelected ? Color(hex: "90EE90") : Color(hex: "228B22").opacity(0.5),
                            lineWidth: isSelected ? 2 : 1
                        )
                )
                .shadow(color: isSelected ? Color(hex: "90EE90").opacity(0.5) : Color.black.opacity(0.5), radius: 4, x: 0, y: 2)
            
            VStack(spacing: 12) {
                // Icon with Glow
                ZStack {
                    Circle()
                        .fill(typeColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .blur(radius: 5)
                    
                    Image(systemName: "leaf.fill") // Placeholder icon
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundColor(typeColor)
                }
                .padding(.top, 16)
                
                VStack(spacing: 4) {
                    // Name
                    Text(herb.name)
                        .font(.system(.headline, design: .serif))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "F0FFF0")) // Honeydew
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    
                    // Scientific Name (Optional, if space permits)
                    // Text(herb.scientificName)
                    //    .font(.system(size: 10, design: .serif))
                    //    .italic()
                    //    .foregroundColor(.gray)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
            }
        }
        .frame(height: 150)
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
