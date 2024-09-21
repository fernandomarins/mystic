//
//  RuneModel.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import Foundation

struct RuneModel: Decodable, Identifiable, Hashable {
    let id: Int
    let name, power: String
    let magic, tree, rock, color: String?
}
