//
//  HerbsModel.swift
//  tarot
//
//  Created by Fernando Marins on 27/09/24.
//

import Foundation

enum HerbType: String, Decodable {
    case hot = "Quente"
    case warm = "Morna"
    case cold = "Frita"
}

struct Herbs: Decodable {
    let herbs: [Herb]
}

// MARK: - Herb
struct Herb: Decodable, Hashable {
    let name, scientificName: String
    let type: HerbType
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case scientificName = "scientific_name"
        case type, description
    }
}
