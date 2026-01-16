//
//  GeomanciaModel.swift
//  tarot
//
//  Created by Antigravity on 15/01/26.
//

import Foundation

struct GeomanciaResponse: Decodable {
    let forms: [GeomanciaMeaning]
    
    enum CodingKeys: String, CodingKey {
        case forms = "geomancia"
    }
}

struct GeomanciaMeaning: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let latinName: String
    let pattern: [Int]
    let element: String
    let planet: String?
    let zodiac: String?
    let nature: String
    let parity: String
    let period: String
    let meaning: String
    let answer: String
}

struct GeomanciaReading: Identifiable, Hashable {
    let id = UUID()
    var question: String = ""
    
    // The 15 figures of the Shield
    var mothers: [[Int]] = [[2,2,2,2], [2,2,2,2], [2,2,2,2], [2,2,2,2]] // M1, M2, M3, M4
    
    // Derived Figures
    var daughters: [[Int]] {
        return (0..<4).map { lineIndex in
            mothers.map { $0[lineIndex] }
        }
    }
    
    var nieces: [[Int]] {
        let n9 = sumPatterns(mothers[0], mothers[1])
        let n10 = sumPatterns(mothers[2], mothers[3])
        let n11 = sumPatterns(daughters[0], daughters[1])
        let n12 = sumPatterns(daughters[2], daughters[3])
        return [n9, n10, n11, n12]
    }
    
    var rightWitness: [Int] { // 13th - Past/Querent
        return sumPatterns(nieces[0], nieces[1])
    }
    
    var leftWitness: [Int] { // 14th - Future/Object
        return sumPatterns(nieces[2], nieces[3])
    }
    
    var judge: [Int] { // 15th
        return sumPatterns(rightWitness, leftWitness)
    }
    
    var reconciler: [Int] { // 16th - Judge + Mother 1
        return sumPatterns(judge, mothers[0])
    }
    
    // Helper for Geomantic Addition
    private func sumPatterns(_ p1: [Int], _ p2: [Int]) -> [Int] {
        return zip(p1, p2).map { (v1, v2) in
            (v1 + v2) % 2 == 0 ? 2 : 1
        }
    }
}
