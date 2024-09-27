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
struct Herb: Codable {
    let description, name: String
}
