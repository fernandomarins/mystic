//
//  AttributeCell.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import SwiftUI

struct AttributeCell: View {
    let title: String
    let value: String?
    let icon: String
    var accentColor: Color = .purple
    
    var body: some View {
        if let value = value, !value.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(accentColor)
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(value)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(nil) // Allow unlimited lines
                    .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "1C1C1E"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
}

#Preview {
    ZStack {
        Color.black
        HStack(alignment: .top) {
            AttributeCell(title: "Short", value: "Value", icon: "star.fill", accentColor: .cyan)
            AttributeCell(title: "Long", value: "This is a very long value that should wrap to multiple lines and expand the cell vertically.", icon: "star.fill")
        }
        .padding()
    }
}
