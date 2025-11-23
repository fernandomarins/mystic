//
//  AstrologyModel.swift
//  tarot
//
//  Created by Fernando Marins on 25/09/24.
//

import Foundation

struct AstrologyModel: Decodable {
    let planets: Planets
}

struct Planets: Decodable, Hashable {
    let sunSigns: [String: String]
    let moonSigns: [String: String]
    let mercurySigns: [String: String]
    let venusSigns: [String: String]
    let marsSigns: [String: String]
    let jupiterSigns: [String: String]
    let saturnSigns: [String: String]
    let uranusSigns: [String: String]
    let neptuneSigns: [String: String]
    let plutoSigns: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case sunSigns = "sun_signs"
        case moonSigns = "moon_signs"
        case mercurySigns = "mercury_signs"
        case venusSigns = "venus_signs"
        case marsSigns = "mars_signs"
        case jupiterSigns = "jupiter_signs"
        case saturnSigns = "saturn_signs"
        case uranusSigns = "uranus_signs"
        case neptuneSigns = "neptune_signs"
        case plutoSigns = "pluto_signs"
    }
}

struct AstrologyInfo {
    let id = UUID()
    let planet, sign: String
}
