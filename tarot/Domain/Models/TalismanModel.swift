//
//  TalismanModel.swift
//  tarot
//
//  Created by Fernando Marins on 06/12/25.
//

import SwiftUI

enum TattwaShape: String, CaseIterable, Identifiable {
    case triangle = "Triângulo"
    case circle = "Círculo"
    case square = "Quadrado"
    case invertedTriangle = "Triângulo Invertido"
    case oval = "Ovo"
    
    var id: String { rawValue }
}

enum PlanetSymbol: String, CaseIterable, Identifiable {
    case sun = "Sol"
    case moon = "Lua"
    case mercury = "Mercúrio"
    case venus = "Vênus"
    case mars = "Marte"
    case jupiter = "Júpiter"
    case saturn = "Saturno"
    case uranus = "Urano"
    case neptune = "Netuno"
    case pluto = "Plutão"
    
    var id: String { rawValue }
    
    var symbol: String {
        switch self {
        case .sun: return "☉"
        case .moon: return "☽"
        case .mercury: return "☿"
        case .venus: return "♀"
        case .mars: return "♂"
        case .jupiter: return "♃"
        case .saturn: return "♄"
        case .uranus: return "♅"
        case .neptune: return "♆"
        case .pluto: return "♇"
        }
    }
    
    var color: Color {
        switch self {
        case .sun: return Color(hex: "FFD700")
        case .moon: return Color(hex: "E8E8E8")
        case .mercury: return Color(hex: "FF8C00")
        case .venus: return Color(hex: "FF69B4")
        case .mars: return Color(hex: "DC143C")
        case .jupiter: return Color(hex: "4169E1") // Changed to blue
        case .saturn: return Color(hex: "DAA520")
        case .uranus: return Color(hex: "00CED1")
        case .neptune: return Color(hex: "4169E1")
        case .pluto: return Color(hex: "8B008B")
        }
    }
}

// MARK: - Placed Symbol
struct PlacedSymbol: Identifiable {
    let id = UUID()
    let planet: PlanetSymbol
    var position: CGPoint
}

// MARK: - Placed Tattwa
struct PlacedTattwa: Identifiable {
    let id = UUID()
    let shape: TattwaShape
    var color: Color
    var position: CGPoint
}

// MARK: - Talisman Configuration
struct TalismanConfiguration {
    var outerShape: TattwaShape = .circle
    var backgroundColor: Color = .purple
    var innerShape: TattwaShape? = nil
    var innerShapeColor: Color = .yellow
    var placedSymbols: [PlacedSymbol] = []
    var placedTattwas: [PlacedTattwa] = []
}
