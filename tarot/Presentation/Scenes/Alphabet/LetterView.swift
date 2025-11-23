//
//  LetterView.swift
//  tarot
//
//  Created by Fernando Marins on 22/09/24.
//

import SwiftUI

struct LetterView: View {
    @Environment(\.colorScheme) var colorScheme

    let letter: LetterModel

    init(letter: LetterModel) {
        self.letter = letter
    }
    
    var body: some View {
        Text(letter.letter)
            .font(.largeTitle)
        HStack {
            Text("Nome da letra:")
            Text(letter.name)
        }
        Image(uiImage: UIImage(named: letter.letter) ?? UIImage())
        VStack {
            HStack {
                Text("Valor:")
                    .bold()
                Text(letter.value.description)
            }
            Divider()
            HStack {
                Text("Pronúncia:")
                    .bold()
                Text(letter.pronunciation)
            }
            Divider()
            HStack {
                Text("Significado:")
                    .bold()
                Text(letter.meaning)
            }
        }
    }
}

#Preview {
    LetterView(letter: .init(letter: "", name: "", value: 1, pronunciation: "", meaning: ""))
}
