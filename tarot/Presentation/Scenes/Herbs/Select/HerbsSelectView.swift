//
//  HerbsSelect.swift
//  tarot
//
//  Created by Fernando Marins on 28/09/24.
//

import SwiftUI

struct HerbsSelectView: View {
    let herbs: [Herb]

    var body: some View {
        if herbs.isEmpty {
            Text("Nenhuma erva selecionada.")
                .foregroundColor(.gray)
        } else {
            List(herbs, id: \.self) { herb in
                Text(herb.name)
                herbTypeCircle(for: herb.type)
            }
            .navigationTitle("Ervas Selecionadas")
        }
    }
    
    private func herbTypeCircle(for type: HerbType) -> some View {
        let color: Color
        switch type {
        case .hot:
            color = .red
        case .warm:
            color = .yellow
        case .cold:
            color = .blue
        }
        return Circle()
            .fill(color)
            .frame(
                width: 20,
                height: 20
            )
    }
}

#Preview {
    HerbsSelectView(herbs: [])
}
