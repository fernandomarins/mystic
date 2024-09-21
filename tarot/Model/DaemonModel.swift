//
//  DaemonModel.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import Foundation

struct DaemonModel: Decodable, Identifiable {
    let id: Int
    let name, enn, description, planet, direction, pathworking: String
    let houses: [String]?
}
