//
//  DignitiesView.swift
//  tarot
//
//  Created by Fernando Marins on 26/09/24.
//

import SwiftUI

enum Dignity: String {
    case ruler = "DOMICÍLIO"
    case detriment = "EXÍLIO"
    case exalted = "EXALTAÇÃO"
    case fall = "QUEDA"
}

struct DignitiesView: View {
    let dignity: Dignity
    
    var body: some View {
        Text(dignity.rawValue)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(dignityColor)
            .cornerRadius(12)
    }
    
    private var dignityColor: Color {
        switch dignity {
        case .ruler:
            return Color(hex: "FFD700") // Gold
        case .exalted:
            return Color(hex: "4169E1") // Blue
        case .detriment:
            return Color(hex: "DC143C") // Red
        case .fall:
            return Color(hex: "696969") // Gray
        }
    }
}

#Preview {
    DignitiesView(dignity: .ruler)
}
