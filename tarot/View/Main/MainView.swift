//
//  MainView.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import SwiftUI

struct MainView: View {
    private let sections: [Main] = [
        .init(id: 0, name: "Tarot"),
        .init(id: 1, name: "Runas"),
        .init(id: 2, name: "Daemons"),
        .init(id: 3, name: "Ossos"),
        .init(id: 4, name: "Alfabeto"),
        .init(id: 5, name: "Astrologia")
//        .init(id: 4, name: "Sangoma e Búzios")
//        .init(id: 4, name: "Runas de Hékate"),
//        .init(id: 5, name: "40 Servidores"),
//        .init(id: 6, name: "Qlipoth")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(0..<((sections.count + 1) / 2), id: \.self) { rowIndex in
                        HStack {
                            ForEach(0..<2, id: \.self) { columnIndex in
                                let sectionIndex = rowIndex * 2 + columnIndex
                                if sectionIndex < sections.count {
                                    NavigationLink(destination: destinationView(for: sections[sectionIndex])) {
                                        CollectionViewCell(name: sections[sectionIndex].name)
                                            .frame(width: 150, height: 150)
                                            .background(Color.purple)
                                            .cornerRadius(16)
                                            .foregroundStyle(.black)
                                    }

                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Tópicos")
        }
    }
    
    @ViewBuilder
    private func destinationView(for section: Main) -> some View {
        switch section.name {
        case "Tarot":
            CardListView()
        case "Runas":
            RuneListView()
        case "Daemons":
            DaemonListView()
        case "Ossos":
            SangomaView()
        case "Alfabeto":
            AlphabetListView()
        case "Astrologia":
            AstrologyListView()
        default:
            CardListView()
        }
    }
}

#Preview {
    MainView()
}
