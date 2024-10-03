//
//  MainView.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import SwiftUI

struct MainView: View {
    private let sections: [Main] = [
        .init(id: 0, name: .tarot),
        .init(id: 1, name: .runes),
        .init(id: 2, name: .daemons),
        .init(id: 3, name: .bones),
        .init(id: 4, name: .alphabet),
        .init(id: 5, name: .astrology),
        .init(id: 6, name: .herbs)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    sectionGrid
                }
            }
            .padding()
            .navigationTitle("Tópicos")
        }
    }
    
    private var sectionGrid: some View {
        ForEach(0..<((sections.count + 1) / 2), id: \.self) { rowIndex in
            sectionRow(for: rowIndex)
        }
    }
    
    private func sectionRow(for rowIndex: Int) -> some View {
        HStack(spacing: 16) {
            ForEach(0..<2, id: \.self) { columnIndex in
                let sectionIndex = rowIndex * 2 + columnIndex
                if sectionIndex < sections.count {
                    sectionCell(for: sections[sectionIndex])
                }
            }
        }
    }
    
    private func sectionCell(for section: Main) -> some View {
        NavigationLink(destination: destinationView(for: section)) {
            CollectionViewCell(name: section.name.rawValue)
                .frame(width: 150, height: 150)
                .background(Color.purple)
                .cornerRadius(16)
                .foregroundStyle(.black)
        }
    }
    
    @ViewBuilder
    private func destinationView(for section: Main) -> some View {
        switch section.name {
        case .tarot:
            CardListView()
        case .runes:
            RuneListView()
        case .daemons:
            DaemonListView()
        case .bones:
            SangomaView()
        case .alphabet:
            AlphabetListView()
        case .astrology:
            AstrologyListView()
        case .herbs:
            HerbsListView()
        }
    }
}

#Preview {
    MainView()
}
