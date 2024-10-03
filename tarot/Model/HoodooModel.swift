//
//  HoodooModel.swift
//  tarot
//
//  Created by Fernando Marins on 03/10/24.
//

import Foundation

struct HoodooModel: Codable {
    let spells: [Spell]
}

// MARK: - Spell
struct Spell: Codable {
    let name, type: String
    let materials: [Material]
    let procedure: String
}

// MARK: - Material
struct Material: Codable {
    let name, quantity: String
}
