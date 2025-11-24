//
//  tarotApp.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import SwiftUI
import SwiftData

@main
struct tarotApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: CardEntity.self)
    }
}
