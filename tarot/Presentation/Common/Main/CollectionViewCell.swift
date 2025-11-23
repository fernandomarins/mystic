//
//  CollectionViewCell.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

//
//  CollectionViewCell.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import SwiftUI

struct CollectionViewCell: View {
    @Environment(\.colorScheme) var colorScheme
    
    let name: String
    private let imageSize: CGFloat = 50
    private let cellWidth: CGFloat = (UIScreen.main.bounds.width / 3)
    
    var body: some View {
        VStack(alignment: .center) {
            nameText
            imageView
        }
        .padding()
    }
    
    private var imageView: some View {
        Image(uiImage: UIImage(named: name) ?? UIImage())
            .resizable()
            .scaledToFill()
            .frame(width: imageSize, height: imageSize)
    }
    
    private var nameText: some View {
        Text(name)
            .font(.subheadline)
    }
}

#Preview {
    CollectionViewCell(name: "Tarot")
}
