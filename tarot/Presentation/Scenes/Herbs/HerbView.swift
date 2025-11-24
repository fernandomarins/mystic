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
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Hero Section
                VStack(spacing: 8) {
                    Image(systemName: "leaf.fill") // Placeholder
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .foregroundColor(typeColor)
                        .shadow(color: typeColor.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text(herb.name)
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(herb.scientificName)
                        .font(.title3)
                        .italic()
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Attributes
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    AttributeCell(
                        title: "Tipo",
                        value: herb.type.rawValue,
                        icon: "flame.fill", // Generic icon, color indicates type
                        accentColor: typeColor
                    )
                    
                    AttributeCell(
                        title: "Nome Científico",
                        value: herb.scientificName,
                        icon: "text.book.closed.fill",
                        accentColor: .purple
                    )
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
                    
                    Text(herb.description)
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineSpacing(4)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "1C1C1E"))
                        )
                }
            }
            .padding()
        }
        .background(Color.black)
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
    HerbView(herb: .init(name: "Lavender", scientificName: "Lavandula angustifolia", type: .cold, description: "Lavender is known for its relaxing and calming effects."))
}
