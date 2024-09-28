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
        ScrollView {
            VStack(spacing: 16) {
                herbTitleSection
                Divider()
                herbTypeSection
                Divider()
                herbDescriptionSection
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
    
    private var herbTitleSection: some View {
        VStack(spacing: 4) {
            Text(herb.name)
                .font(.title)
                .bold()
            
            Text(herb.scientificName)
                .font(.caption)
                .italic()
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var herbTypeSection: some View {
        HStack {
            Text("Tipo:")
                .bold()
            Text(herb.type.rawValue.capitalized)
                .textCase(.lowercase)
            herbTypeCircle
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var herbDescriptionSection: some View {
        Text(herb.description)
            .font(.body)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var herbTypeCircle: some View {
        let color: Color
        switch herb.type {
        case .hot:
            color = .red
        case .warm:
            color = .yellow
        case .cold:
            color = .blue
        }
        return Circle()
            .fill(color)
            .frame(width: 20, height: 20)
    }
}

#Preview {
    HerbView(herb: .init(name: "Lavender", scientificName: "Lavandula angustifolia", type: .cold, description: "Lavender is known for its relaxing and calming effects."))
}
