//
//  RPGModel.swift
//  tarot
//
//  Created by Fernando Marins on 04/12/25.
//

import Foundation
import SwiftUI

enum RPGPart: String, CaseIterable {
    case alignment = "Alinhamento"
    case pentagrams = "Pentagramas"
    case closing = "Encerramento"
}

struct RPGStep: Identifiable {
    let id = UUID()
    let part: RPGPart
    let instruction: String
    let mantra: String?
    let visualization: String?
    let direction: Double? // 0 = North, 90 = East, 180 = South, 270 = West
    let isCompassStep: Bool
}

struct RPGModel {
    static let steps: [RPGStep] = [
        // PART I - Alignment
        .init(part: .alignment, instruction: "Posicione-se em pé, pés alinhados com o quadril. Inspire profundamente.", mantra: nil, visualization: nil, direction: nil, isCompassStep: false),
        .init(part: .alignment, instruction: "Entoe o mantra 'I' até esvaziar o pulmão.", mantra: "I", visualization: "Esfera de luz na cabeça", direction: nil, isCompassStep: false),
        .init(part: .alignment, instruction: "Entoe o mantra 'E' até esvaziar o pulmão.", mantra: "E", visualization: "Esfera de luz no pescoço", direction: nil, isCompassStep: false),
        .init(part: .alignment, instruction: "Entoe o mantra 'A' até esvaziar o pulmão.", mantra: "A", visualization: "Esfera de luz no coração", direction: nil, isCompassStep: false),
        .init(part: .alignment, instruction: "Entoe o mantra 'O' até esvaziar o pulmão.", mantra: "O", visualization: "Esfera de luz na barriga", direction: nil, isCompassStep: false),
        .init(part: .alignment, instruction: "Entoe o mantra 'U' até esvaziar o pulmão.", mantra: "U", visualization: "Esfera de luz no quadril", direction: nil, isCompassStep: false),
        .init(part: .alignment, instruction: "Repita o mantra 'U'.", mantra: "U", visualization: "Esfera de luz no quadril", direction: nil, isCompassStep: false),
        .init(part: .alignment, instruction: "Repita o mantra 'O'.", mantra: "O", visualization: "Esfera de luz na barriga", direction: nil, isCompassStep: false),
        .init(part: .alignment, instruction: "Repita o mantra 'A'.", mantra: "A", visualization: "Esfera de luz no coração", direction: nil, isCompassStep: false),
        .init(part: .alignment, instruction: "Repita o mantra 'E'.", mantra: "E", visualization: "Esfera de luz no pescoço", direction: nil, isCompassStep: false),
        .init(part: .alignment, instruction: "Repita o mantra 'I'.", mantra: "I", visualization: "Esfera de luz na cabeça", direction: nil, isCompassStep: false),
        
        // PART II - Pentagrams
        // 1st Pentagram (Front/East)
        .init(part: .pentagrams, instruction: "Vire-se para o Leste (ou Frente).", mantra: nil, visualization: nil, direction: 90, isCompassStep: true),
        .init(part: .pentagrams, instruction: "Desenhe o pentagrama no ar.", mantra: "IEAOU", visualization: "Pentagrama brilhando", direction: 90, isCompassStep: false),
        
        // 2nd Pentagram (South)
        .init(part: .pentagrams, instruction: "Gire 90º para a direita (Sul).", mantra: nil, visualization: nil, direction: 180, isCompassStep: true),
        .init(part: .pentagrams, instruction: "Desenhe o pentagrama no ar.", mantra: "IEAOU", visualization: "Pentagrama brilhando", direction: 180, isCompassStep: false),
        
        // 3rd Pentagram (West)
        .init(part: .pentagrams, instruction: "Gire 90º para a direita (Oeste).", mantra: nil, visualization: nil, direction: 270, isCompassStep: true),
        .init(part: .pentagrams, instruction: "Desenhe o pentagrama no ar.", mantra: "IEAOU", visualization: "Pentagrama brilhando", direction: 270, isCompassStep: false),
        
        // 4th Pentagram (North)
        .init(part: .pentagrams, instruction: "Gire 90º para a direita (Norte).", mantra: nil, visualization: nil, direction: 0, isCompassStep: true),
        .init(part: .pentagrams, instruction: "Desenhe o pentagrama no ar.", mantra: "IEAOU", visualization: "Pentagrama brilhando", direction: 0, isCompassStep: false),
        
        // Return to start
        .init(part: .pentagrams, instruction: "Complete o giro (Leste).", mantra: nil, visualization: "4 Pentagramas ao redor", direction: 90, isCompassStep: true),
        
        // PART III - Closing
        .init(part: .closing, instruction: "Inspire profundamente.", mantra: nil, visualization: nil, direction: nil, isCompassStep: false),
        .init(part: .closing, instruction: "Repita a formação das esferas (I-E-A-O-U-U-O-A-E-I).", mantra: "IEAOU...", visualization: "Esferas de luz", direction: nil, isCompassStep: false),
        .init(part: .closing, instruction: "Encerre visualizando os 4 pentagramas.", mantra: nil, visualization: "Pentagramas e Esferas", direction: nil, isCompassStep: false)
    ]
}
