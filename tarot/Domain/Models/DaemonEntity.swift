//
//  DaemonEntity.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation
import SwiftData

@Model
class DaemonEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var enn: String
    var desc: String
    var planet: String
    var direction: String
    var pathworking: String
    var houses: [String]?
    
    init(daemon: DaemonModel) {
        self.id = daemon.id
        self.name = daemon.name
        self.enn = daemon.enn
        self.desc = daemon.description
        self.planet = daemon.planet
        self.direction = daemon.direction
        self.pathworking = daemon.pathworking
        self.houses = daemon.houses
    }
    
    func toModel() -> DaemonModel {
        DaemonModel(
            id: id,
            name: name,
            enn: enn,
            description: desc,
            planet: planet,
            direction: direction,
            pathworking: pathworking,
            houses: houses
        )
    }
}
