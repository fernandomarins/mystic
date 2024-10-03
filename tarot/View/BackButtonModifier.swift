//
//  BackButtonModifier.swift
//  tarot
//
//  Created by Fernando Marins on 28/09/24.
//

import SwiftUI

struct BackButtonModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss.callAsFunction()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.purple)
                    }
                }
            }
    }
}

extension View {
    func backButtonStyle() -> some View {
        self.modifier(BackButtonModifier())
    }
}

