//
//  AstrologySwiftDataModel.swift
//  tarot
//
//  Created by Fernando Marins on 24/11/24.
//

import Foundation
import SwiftData

@Model
class PlanetEntity {
    @Attribute(.unique) var name: String
    var signDescriptions: [String: String]
    
    init(name: String, signDescriptions: [String: String]) {
        self.name = name
        self.signDescriptions = signDescriptions
    }
}
