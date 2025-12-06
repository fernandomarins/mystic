//
//  LuciferianModel.swift
//  tarot
//
//  Created by Fernando Marins on 04/12/25.
//

import Foundation
import SwiftUI

enum LuciferianPart: String, CaseIterable {
    case blackCross = "Cruz Negra"
    case callingEntities = "Chamamento das Entidades"
    case conjuration = "Conjuração"
    case closing = "Encerramento"
}

struct LuciferianStep: Identifiable {
    let id = UUID()
    let part: LuciferianPart
    let instruction: String
    let mantra: String?
    let visualization: String?
    let direction: Double? // 0 = North, 90 = East, 180 = South, 270 = West
    let isCompassStep: Bool
}

struct LuciferianModel {
    static let steps: [LuciferianStep] = [
        // PART I - Black Cross
        .init(part: .blackCross, instruction: "Vire-se para o Leste.", mantra: nil, visualization: "Linha de luz negra intensa acompanhando as mãos", direction: 90, isCompassStep: true),
        .init(part: .blackCross, instruction: "Toque o meio da testa (Mão Esquerda: Indicador + Médio).", mantra: "OIAD", visualization: "Luz negra no topo da cabeça", direction: 90, isCompassStep: false),
        .init(part: .blackCross, instruction: "Toque a área genital (Mão Esquerda).", mantra: "MOLAP", visualization: "Feixe de luz negra descendo até os pés", direction: 90, isCompassStep: false),
        .init(part: .blackCross, instruction: "Toque o ombro esquerdo (Mão Direita: Indicador + Médio).", mantra: "BAEOUIB", visualization: "Luz negra no ombro esquerdo", direction: 90, isCompassStep: false),
        .init(part: .blackCross, instruction: "Toque o ombro direito (Mão Esquerda: Indicador + Médio).", mantra: "IEHUSOZ", visualization: "Luz negra do ombro direito para o esquerdo", direction: 90, isCompassStep: false),
        
        // PART II - Calling Entities
        // West - Leviathan
        .init(part: .callingEntities, instruction: "Vire-se para o Oeste.", mantra: nil, visualization: "Pentagrama invertido de fogo", direction: 270, isCompassStep: true),
        .init(part: .callingEntities, instruction: "Chame Leviatã.", mantra: "Jaden Tasa Hoet Naca Leviathan!", visualization: "Pentagrama invertido de fogo", direction: 270, isCompassStep: false),
        
        // South - Satan
        .init(part: .callingEntities, instruction: "Vire-se para o Sul.", mantra: nil, visualization: "Pentagrama invertido de fogo", direction: 180, isCompassStep: true),
        .init(part: .callingEntities, instruction: "Chame Satã.", mantra: "Tasa Reme Laris Satanis!", visualization: "Pentagrama invertido de fogo", direction: 180, isCompassStep: false),
        
        // East - Lucifer
        .init(part: .callingEntities, instruction: "Vire-se para o Leste.", mantra: nil, visualization: "Pentagrama invertido de fogo", direction: 90, isCompassStep: true),
        .init(part: .callingEntities, instruction: "Chame Lúcifer.", mantra: "Renich tasa uberaca icar Lúcifer!", visualization: "Pentagrama invertido de fogo", direction: 90, isCompassStep: false),
        
        // North - Beelzebub
        .init(part: .callingEntities, instruction: "Vire-se para o Norte.", mantra: nil, visualization: "Pentagrama invertido de fogo", direction: 0, isCompassStep: true),
        .init(part: .callingEntities, instruction: "Chame Belial.", mantra: "Lirach Tasa Vefa Wehlic!", visualization: "Pentagrama invertido de fogo", direction: 0, isCompassStep: false),
        
        // PART III - Conjuration (South)
        .init(part: .conjuration, instruction: "Vire-se para o Sul novamente.", mantra: nil, visualization: nil, direction: 180, isCompassStep: true),
        .init(part: .conjuration, instruction: "Faça a conjuração de Satã.", mantra: "In Nomine Magni Dei Nostri\nSatana-Luciferi Excelsi\nIntroibo ad altare Domini Inferi\nQui regit terram\nDomini Satannas Rex Infernus!", visualization: nil, direction: 180, isCompassStep: false),
        .init(part: .conjuration, instruction: "Insira dizeres de banimento ou limpeza.", mantra: nil, visualization: nil, direction: 180, isCompassStep: false),
        
        // PART IV - Closing
        .init(part: .closing, instruction: "Vire-se para o Leste.", mantra: nil, visualization: nil, direction: 90, isCompassStep: true),
        .init(part: .blackCross, instruction: "Toque o meio da testa (Mão Esquerda: Indicador + Médio).", mantra: "OIAD", visualization: "Luz negra no topo da cabeça", direction: 90, isCompassStep: false),
        .init(part: .blackCross, instruction: "Toque a área genital (Mão Esquerda).", mantra: "MOLAP", visualization: "Feixe de luz negra descendo até os pés", direction: 90, isCompassStep: false),
        .init(part: .blackCross, instruction: "Toque o ombro esquerdo (Mão Direita: Indicador + Médio).", mantra: "BAEOUIB", visualization: "Luz negra no ombro esquerdo", direction: 90, isCompassStep: false),
        .init(part: .blackCross, instruction: "Toque o ombro direito (Mão Esquerda: Indicador + Médio).", mantra: "IEHUSOZ", visualization: "Luz negra do ombro direito para o esquerdo", direction: 90, isCompassStep: false),
        
        // Clockwise Turn (N -> W -> S -> E -> N) - Simplified to just "Turn Clockwise" instructions or specific points?
        // "Começou no Oeste e terminou no Norte" -> Wait, the calling started West.
        // "Deve ir em sentido horário (do Norte ao Oeste) agradecendo... fechando no Norte novamente."
        // Let's guide N -> E -> S -> W -> N (Clockwise)
        
        .init(part: .closing, instruction: "Vire-se para o Norte.", mantra: nil, visualization: "Agradeça Belial", direction: 0, isCompassStep: true),
        .init(part: .closing, instruction: "Gire sentido horário para o Leste.", mantra: nil, visualization: "Agradeça Lúcifer", direction: 90, isCompassStep: true),
        .init(part: .closing, instruction: "Gire sentido horário para o Sul.", mantra: nil, visualization: "Agradeça Leviatã", direction: 180, isCompassStep: true),
        .init(part: .closing, instruction: "Gire sentido horário para o Oeste.", mantra: nil, visualization: "Agradeça Leviatã", direction: 270, isCompassStep: true),
        .init(part: .closing, instruction: "Gire sentido horário para o Norte (Fechar).", mantra: nil, visualization: nil, direction: 0, isCompassStep: true),
        
        .init(part: .closing, instruction: "Levante a mão esquerda chifrada.", mantra: "Ágios Satã / Ave Satã / Salve Satã", visualization: "Sinal de lealdade", direction: 0, isCompassStep: false)
    ]
}
