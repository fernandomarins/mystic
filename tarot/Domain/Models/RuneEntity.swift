//
//  RuneEntity.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation
import SwiftData

@Model
class RuneEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var power: String
    var magic: String?
    var tree: String?
    var rock: String?
    var color: String?
    
    init(rune: RuneModel) {
        self.id = rune.id
        self.name = rune.name
        self.power = rune.power
        self.magic = rune.magic
        self.tree = rune.tree
        self.rock = rune.rock
        self.color = rune.color
    }
    
    func toModel() -> RuneModel {
        RuneModel(
            id: id,
            name: name,
            power: power,
            magic: magic,
            tree: tree,
            rock: rock,
            color: color
        )
    }
}
