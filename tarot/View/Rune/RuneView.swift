//
//  RuneView.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct RuneView: View {
    @Environment(\.colorScheme) private var colorScheme

    let rune: RuneModel
    
    private var sectionColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Text(rune.name)
                .font(.title)
                .bold()
            Rectangle()
                .fill(sectionColor)
                .frame(height: 4)
                .frame(maxWidth: .infinity)
            
            Spacer(minLength: 32)
            
            Image(uiImage: UIImage(named: rune.name) ?? UIImage())
                .frame(height: 100)
                .scaledToFit()
            
            VStack(alignment: .leading) {
                runeSection(title: "Efeitos", content: rune.power)
                runeSection(title: "Magia", content: rune.magic)
                runeSection(title: "Árvore", content: rune.tree)
                runeSection(title: "Pedra(s)", content: rune.rock)
                runeSection(title: "Cor", content: rune.color)
            }
            .padding()
        }
    }
    
    private func runeSection(title: String, content: String?) -> some View {
        Group {
            if let content = content, !content.isEmpty {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title2)
                        .bold()
                    Text(content)
                    Rectangle()
                        .fill(sectionColor)
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    RuneView(rune: .init(id: 0, name: "", power: "", magic: "", tree: "", rock: "", color: ""))
}
