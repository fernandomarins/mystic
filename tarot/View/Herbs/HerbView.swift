//
//  HerbView.swift
//  tarot
//
//  Created by Fernando Marins on 28/09/24.
//

import SwiftUI

struct HerbView: View {
    let herb: Herb
    init(herb: Herb) {
        self.herb = herb
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HerbView(herb: .init(name: "", scientificName: "", type: .cold, description: ""))
}
