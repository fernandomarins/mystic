//
//  DignitiesView.swift
//  tarot
//
//  Created by Fernando Marins on 26/09/24.
//

import SwiftUI

enum Dignity: String {
    case ruler
    case detriment
    case exalted
    case fall
}

struct DignitiesView: View {
    let dignity: Dignity
    
    init(dignity: Dignity) {
        self.dignity = dignity
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 80, height: 40))
                .foregroundStyle(changeColor())
                .frame(width: 100, height: 20)
            Text(addText())
                .bold()
                .font(.caption)
        }
    }
    
    private func changeColor() -> Color {
        switch dignity {
        case .ruler:
            .blue
        case .detriment:
            .red
        case .exalted:
            .yellow
        case .fall:
            .gray
        }
    }
    
    private func addText() -> String {
        switch dignity {
        case .ruler:
            "DOMICÍLIO"
        case .detriment:
            "EXÍLIO"
        case .exalted:
            "EXALTAÇÃO"
        case .fall:
            "QUEDA"
        }
    }
}

#Preview {
    DignitiesView(dignity: Dignity(rawValue: "ruler") ?? .detriment)
}
