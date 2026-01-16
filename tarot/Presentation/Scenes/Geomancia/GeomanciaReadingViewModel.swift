//
//  GeomanciaReadingViewModel.swift
//  tarot
//
//  Created by Antigravity on 15/01/26.
//

import SwiftUI

class GeomanciaReadingViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var reading: GeomanciaReading = GeomanciaReading()
    @Published var meanings: [GeomanciaMeaning] = []
    @Published var selectedHouse: HouseDefinition? = nil
    
    init() {
        loadMeanings()
    }
    
    func loadMeanings() {
        guard let url = Bundle.main.url(forResource: "geomancia", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(GeomanciaResponse.self, from: data)
            meanings = response.forms
        } catch {
            print("Error loading meanings for reading: \(error)")
        }
    }
    
    // Step navigation
    func nextStep() {
        if currentStep < 2 {
            withAnimation {
                currentStep += 1
            }
        }
    }
    
    func prevStep() {
        if currentStep > 0 {
            withAnimation {
                currentStep -= 1
            }
        }
    }
    
    func reset() {
        currentStep = 0
        reading = GeomanciaReading()
    }
    
    // Helper to find meaning by pattern
    func meaning(for pattern: [Int]) -> GeomanciaMeaning? {
        return meanings.first { $0.pattern == pattern }
    }
    
    // Toggle a specific line in a Mother figure (between 1 and 2 dots)
    func toggleMotherLine(motherIndex: Int, lineIndex: Int) {
        if motherIndex < 4 && lineIndex < 4 {
            let currentValue = reading.mothers[motherIndex][lineIndex]
            reading.mothers[motherIndex][lineIndex] = currentValue == 1 ? 2 : 1
            
            // Force refresh since mothers is an array within a struct
            let updatedMothers = reading.mothers
            reading.mothers = updatedMothers
        }
    }
    
    // MARK: - 12 Houses Logic
    
    struct HouseDefinition: Identifiable {
        let id: Int
        let name: String
        let icon: String
        let description: String
        let quality: String // Angular, Sucedente, Cadente
    }
    
    let housesData: [HouseDefinition] = [
        HouseDefinition(id: 1, name: "Casa 1 (I - Vita): A Vida", icon: "🏹", description: "O consulente, sua saúde física, personalidade e caráter. Representa o início de empreendimentos e a perspectiva geral de vida no momento.", quality: "Angular (Forte/Rápida)"),
        HouseDefinition(id: 2, name: "Casa 2 (II - Lucrum): O Lucro", icon: "💰", description: "Bens materiais, recursos, dinheiro e posses móveis. Representa a capacidade de ganho, além de roubos (exceto imóveis).", quality: "Sucedente (Moderada/Estável)"),
        HouseDefinition(id: 3, name: "Casa 3 (III - Fratres): Os Irmãos", icon: "🧠", description: "Irmãos, vizinhos e ambiente imediato. Viagens curtas por terra, comunicações, notícias, educação básica e habilidades práticas.", quality: "Cadente (Fraca/Atrasos)"),
        HouseDefinition(id: 4, name: "Casa 4 (IV - Genitor): O Pai", icon: "🏠", description: "O pai, herança paterna, lar e vida doméstica. Rege bens imóveis, tesouros ocultos e o 'Fim da Questão' (resultado final a longo prazo).", quality: "Angular (Forte/Rápida)"),
        HouseDefinition(id: 5, name: "Casa 5 (V - Nati): Os Filhos", icon: "❤️", description: "Filhos, gravidez, prazeres, banquetes e romance. Também rege investimentos (especulação), jogos de azar e mensageiros.", quality: "Sucedente (Moderada/Estável)"),
        HouseDefinition(id: 6, name: "Casa 6 (VI - Valetudo): A Saúde", icon: "⚙️", description: "Doenças físicas, serviço e ambiente de trabalho. Na tradição, rege também empregados e animais pequenos (menores que uma cabra).", quality: "Cadente (Fraca/Atrasos)"),
        HouseDefinition(id: 7, name: "Casa 7 (VII - Uxor): O Cônjuge", icon: "🤝", description: "Casamento, parcerias de negócios e contratos. Representa o 'outro', oponentes, processos judiciais e inimigos declarados.", quality: "Angular (Forte/Rápida)"),
        HouseDefinition(id: 8, name: "Casa 8 (VIII - Mors): A Morte", icon: "☠️", description: "A morte e sua natureza. Heranças, dinheiro de terceiros, crise, magia praticada pelo consulente e pessoas desaparecidas.", quality: "Sucedente (Moderada/Estável)"),
        HouseDefinition(id: 9, name: "Casa 9 (IX - Iter): As Viagens", icon: "🌍", description: "Viagens longas (exterior/mar), religião, filosofia, lei, ensino superior e sabedoria. A mente superior e visões proféticas.", quality: "Cadente (Fraca/Atrasos)"),
        HouseDefinition(id: 10, name: "Casa 10 (X - Regnum): O Reino", icon: "👑", description: "Carreira, profissão, honra e autoridade. Reis, juízes e poder. No contexto familiar, Greer associa esta casa à mãe.", quality: "Angular (Forte/Rápida)"),
        HouseDefinition(id: 11, name: "Casa 11 (XI - Benefacta): Os Amigos", icon: "🧑‍🤝‍🧑", description: "Amigos, aliados, protetores. Esperanças, desejos e o apoio de grupos, além de fontes de ajuda e perguntas secretas.", quality: "Sucedente (Moderada/Estável)"),
        HouseDefinition(id: 12, name: "Casa 12 (XII - Carcer): A Prisão", icon: "🌑", description: "Prisões, confinamento, inimigos ocultos e autossabotagem. Dívidas, trabalho feito por outros e animais grandes.", quality: "Cadente (Fraca/Atrasos)")
    ]
    
    var isCorrupted: Bool {
        // Rubeus [2,1,2,2] or Cauda Draconis [2,1,1,1]
        let criticalPatterns = [[2,1,2,2], [2,1,1,1]]
        let judgePattern = reading.judge
        let m1Pattern = reading.mothers[0]
        
        return criticalPatterns.contains(judgePattern) || criticalPatterns.contains(m1Pattern)
    }
    
    // Map figures to houses based on Shield
    func figurePattern(forHouse houseId: Int) -> [Int] {
        switch houseId {
        case 1...4: return reading.mothers[houseId - 1]
        case 5...8: return reading.daughters[houseId - 5]
        case 9...12: return reading.nieces[houseId - 9]
        default: return [2,2,2,2]
        }
    }
    
    // MARK: - Advanced Calculations (O Zigurate)
    
    // Somar todos os pontos das 15 figuras (Escudo)
    var totalPoints: Int {
        let allPatterns = reading.mothers + reading.daughters + reading.nieces + [reading.rightWitness, reading.leftWitness, reading.judge]
        return allPatterns.flatMap { $0 }.reduce(0, +)
    }
    
    // Veredito de Tempo baseado nos pontos (Referência: 96)
    var timingVerdict: String {
        let points = totalPoints
        if points < 96 {
            return "Mais rápido que o esperado"
        } else if points == 96 {
            return "No tempo esperado"
        } else {
            return "Mais lento que o esperado (atrasos)"
        }
    }
    
    // Parte da Fortuna: (soma pontos das 12 casas) % 12. 0 = Casa 12.
    var partOfFortuneHouse: Int {
        let housePatterns = reading.mothers + reading.daughters + reading.nieces
        let sum = housePatterns.flatMap { $0 }.reduce(0, +)
        let result = sum % 12
        return result == 0 ? 12 : result
    }
    
    // Índice (Ponto do Espírito): (pontos ativos/1 pt das 12 casas) % 12. 0 = Casa 12.
    var spiritIndexHouse: Int {
        let housePatterns = reading.mothers + reading.daughters + reading.nieces
        let activePoints = housePatterns.flatMap { $0 }.filter { $0 == 1 }.count
        let result = activePoints % 12
        return result == 0 ? 12 : result
    }
}
