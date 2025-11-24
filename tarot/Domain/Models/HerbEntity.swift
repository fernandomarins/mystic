//
//  HerbEntity.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation
import SwiftData

@Model
class HerbEntity {
    @Attribute(.unique) var name: String
    var scientificName: String
    var type: String
    var desc: String
    
    init(herb: Herb) {
        self.name = herb.name
        self.scientificName = herb.scientificName
        self.type = herb.type.rawValue
        self.desc = herb.description
    }
    
    func toModel() -> Herb {
        Herb(
            name: name,
            scientificName: scientificName,
            type: HerbType(rawValue: type) ?? .hot,
            description: desc
        )
    }
}
