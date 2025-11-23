//
//  SangomaModel.swift
//  tarot
//
//  Created by Fernando Marins on 20/09/24.
//

import Foundation

struct SangomaModel: Decodable, Hashable {
    let bones: [BoneModel]
    let buzios: [BuzioModel]
    
    static func == (lhs: SangomaModel, rhs: SangomaModel) -> Bool {
        lhs.bones == rhs.bones &&
        lhs.buzios == rhs.buzios
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(bones)
        hasher.combine(buzios)
    }
}

struct BoneModel: Decodable, Equatable, Hashable {
    let name, description: String
}

struct BuzioModel: Decodable, Equatable, Hashable {
    let name, description: String
}
