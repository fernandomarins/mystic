//
//  HerbsModel.swift
//  tarot
//
//  Created by Fernando Marins on 27/09/24.
//

import Foundation

struct Herbs: Codable {
    let herbs: [Herb]
}

// MARK: - Herb
struct Herb: Codable, Hashable {
    let name, scientificName, type, description: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case scientificName = "scientific_name"
        case type, description
    }
}
