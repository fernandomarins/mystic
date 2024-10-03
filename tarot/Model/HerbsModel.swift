//
//  HerbsModel.swift
//  tarot
//
//  Created by Fernando Marins on 27/09/24.
//

import Foundation

enum HerbType: String, Codable, CaseIterable {
    case hot = "Quente"
    case warm = "Morna"
    case cold = "Fria"
}

struct Herbs: Codable {
    let herbs: [Herb]
}

// MARK: - Herb
struct Herb: Codable, Hashable {
    let name, scientificName: String
    let type: HerbType
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case scientificName = "scientific_name"
        case type, description
    }
}
