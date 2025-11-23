//
//  HoodooModel.swift
//  tarot
//
//  Created by Fernando Marins on 03/10/24.
//

import Foundation

enum HoodooType: String, Decodable {
    case spell = "feitiço"
    case oil = "óleo"
    case jar
    case mojo
    case grisgris
}

struct HoodooModel: Decodable {
    let items: [HoodooItem]
}

// MARK: - Spell
struct HoodooItem: Decodable, Hashable {
    let name: String
    let type: HoodooType
    let materials: [Material]
    let procedure: String?
    let use: String?
    let categoryType: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case type
        case materials
        case procedure
        case use
        case categoryType = "category_type"
    }
    
    static func == (lhs: HoodooItem, rhs: HoodooItem) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

// MARK: - Material
struct Material: Decodable, Hashable {
    let name: String
}
