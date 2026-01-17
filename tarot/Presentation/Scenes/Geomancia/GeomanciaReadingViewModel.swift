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
        HouseDefinition(id: 1, name: "Casa 1 (I - Vita): A Vida", icon: "🏹", description: "Representa o/a consulente;", quality: "Angular (Forte/Rápida)"),
        HouseDefinition(id: 2, name: "Casa 2 (II - Lucrum): O Lucro", icon: "💰", description: "Dinheiro e propriedade móvel, lucro, renda, investimentos, posses pessoais, roubos, exceto imóveis (4) e especulação (5);", quality: "Sucedente (Moderada/Estável)"),
        HouseDefinition(id: 3, name: "Casa 3 (III - Fratres): Os Irmãos", icon: "🧠", description: "Irmãos, vizinhos, cercanias, jornadas curtas, educação básica, conselho, notícias e boatos;", quality: "Cadente (Fraca/Atrasos)"),
        HouseDefinition(id: 4, name: "Casa 4 (IV - Genitor): O Pai", icon: "🏠", description: "Terreno, agricultura, construção, cidades, mudança de casa, coisas subterrâneas, lugares antigos, idade avançada, o pai, o fim de qualquer questão;", quality: "Angular (Forte/Rápida)"),
        HouseDefinition(id: 5, name: "Casa 5 (V - Nati): Os Filhos", icon: "❤️", description: "Colheitas bianuais, fertilidade, gravidez, filhos, sexualidade, festas e entretenimentos, comida e bebida, roupas, água, pescaria e chuva, cartas e livros;", quality: "Sucedente (Moderada/Estável)"),
        HouseDefinition(id: 6, name: "Casa 6 (VI - Valetudo): A Saúde", icon: "⚙️", description: "Empregados, prestadores de serviço, magos contratados, animais domésticos (exceto animais de carga), doenças e ferimentos;", quality: "Cadente (Fraca/Atrasos)"),
        HouseDefinition(id: 7, name: "Casa 7 (VII - Uxor): O Cônjuge", icon: "🤝", description: "Relações intensas, maridos e esposas, amor e casamento, parcerias, acordos e tratados, conflitos e competições, ladrões e inimigos conhecidos, caça e localização de coisas, médicos", quality: "Angular (Forte/Rápida)"),
        HouseDefinition(id: 8, name: "Casa 8 (VIII - Mors): A Morte", icon: "☠️", description: "Morte, espíritos, assassinato, magia praticada pelo consulente, pessoas desaparecidas, dinheiro e propriedade emprestados;", quality: "Sucedente (Moderada/Estável)"),
        HouseDefinition(id: 9, name: "Casa 9 (IX - Iter): As Viagens", icon: "🌍", description: "Jornadas externas e internas, religião e espiritualidade, educação superior, artes, interpretação de sonhos, filosofia oculta e adivinhação;", quality: "Cadente (Fraca/Atrasos)"),
        HouseDefinition(id: 10, name: "Casa 10 (X - Regnum): O Reino", icon: "👑", description: "Carreira, reputação, lugar na sociedade, política, meteorologia, tratamento médico;", quality: "Angular (Forte/Rápida)"),
        HouseDefinition(id: 11, name: "Casa 11 (XI - Benefacta): Os Amigos", icon: "🧑‍🤝‍🧑", description: "Amigos, sócios, promessas, fontes de ajuda, esperanças e desejos, colheitas anuais, perguntas que o consulente não quer revelar;", quality: "Sucedente (Moderada/Estável)"),
        HouseDefinition(id: 12, name: "Casa 12 (XII - Carcer): A Prisão", icon: "🌑", description: "Restrições e limitações, dívidas do consulente, prisão, coisas secretas, inimigos desconhecidos, trabalho feito pelos outros, animais de carga e selvagens.", quality: "Cadente (Fraca/Atrasos)")
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
    
    // MARK: - Via Puncti (Caminho dos Pontos)
    
    struct ViaPunctiStep: Identifiable {
        let id = UUID()
        let parentTitle: String
        let figureTitle: String
        let pattern: [Int]
        let houseId: Int?
    }
    
    var viaPunctiPath: [ViaPunctiStep] {
        var path: [ViaPunctiStep] = []
        let judge = reading.judge
        let parity = judge[0]
        
        // 1. Trace Witnesses
        if reading.rightWitness[0] == parity {
            path.append(ViaPunctiStep(parentTitle: "O Juiz", figureTitle: "Testemunha Dir. (13)", pattern: reading.rightWitness, houseId: 13))
            traceNiece(0, parity: parity, from: "Testemunha Dir. (13)", path: &path) // N9
            traceNiece(1, parity: parity, from: "Testemunha Dir. (13)", path: &path) // N10
        }
        
        if reading.leftWitness[0] == parity {
            path.append(ViaPunctiStep(parentTitle: "O Juiz", figureTitle: "Testemunha Esq. (14)", pattern: reading.leftWitness, houseId: 14))
            traceNiece(2, parity: parity, from: "Testemunha Esq. (14)", path: &path) // N11
            traceNiece(3, parity: parity, from: "Testemunha Esq. (14)", path: &path) // N12
        }
        
        return path
    }
    
    private func traceNiece(_ index: Int, parity: Int, from: String, path: inout [ViaPunctiStep]) {
        let pattern = reading.nieces[index]
        if pattern[0] == parity {
            let title = "Sobrinha \(index + 9)"
            path.append(ViaPunctiStep(parentTitle: from, figureTitle: title, pattern: pattern, houseId: index + 9))
            
            // N9: M1+M2, N10: M3+M4, N11: D5+D6, N12: D7+D8
            switch index {
            case 0:
                traceLevel1(0, isMother: true, parity: parity, from: title, path: &path)
                traceLevel1(1, isMother: true, parity: parity, from: title, path: &path)
            case 1:
                traceLevel1(2, isMother: true, parity: parity, from: title, path: &path)
                traceLevel1(3, isMother: true, parity: parity, from: title, path: &path)
            case 2:
                traceLevel1(0, isMother: false, parity: parity, from: title, path: &path)
                traceLevel1(1, isMother: false, parity: parity, from: title, path: &path)
            case 3:
                traceLevel1(2, isMother: false, parity: parity, from: title, path: &path)
                traceLevel1(3, isMother: false, parity: parity, from: title, path: &path)
            default: break
            }
        }
    }
    
    private func traceLevel1(_ index: Int, isMother: Bool, parity: Int, from: String, path: inout [ViaPunctiStep]) {
        let pattern = isMother ? reading.mothers[index] : reading.daughters[index]
        if pattern[0] == parity {
            let group = isMother ? "Mãe" : "Filha"
            let groupIndex = isMother ? index + 1 : index + 5
            path.append(ViaPunctiStep(parentTitle: from, figureTitle: "\(group) \(groupIndex)", pattern: pattern, houseId: groupIndex))
        }
    }
    
    // MARK: - Perfection Logic (Perfeição)
    
    struct PerfectionResult: Identifiable {
        let id = UUID()
        let isPerfected: Bool
        let type: PerfectionType
        let description: String
        let querentFigureName: String
        let quesitedFigureName: String
        let qualityAssessment: String? // New: describes if the "Yes" is favorable or not
        let querentAnswer: String? // The "answer" field from querent figure
        let quesitedAnswer: String? // The "answer" field from quesited figure
        let conjunctionDetails: String? // Detailed explanation for conjunction type
    }
    
    enum PerfectionType: String {
        case occupation = "Ocupação"
        case conjunction = "Conjunção"
        case mutation = "Mutação"
        case none = "Nenhuma"
    }
    
    func checkPerfection(quesitedHouse: Int) -> PerfectionResult {
        // Querent is always House 1
        let querentHouse = 1
        let h1Pattern = figurePattern(forHouse: querentHouse)
        let hQPattern = figurePattern(forHouse: quesitedHouse)
        
        let querentMeaning = meaning(for: h1Pattern)
        let quesitedMeaning = meaning(for: hQPattern)
        
        let querentName = querentMeaning?.latinName ?? "Significador"
        let quesitedName = quesitedMeaning?.latinName ?? "Quesito"
        
        let querentAnswer = querentMeaning?.answer
        let quesitedAnswer = quesitedMeaning?.answer
        
        // 1. Occupation: The same figure appears in both houses
        if h1Pattern == hQPattern {
            let quality = assessQuality(querentAnswer: querentAnswer, quesitedAnswer: quesitedAnswer, querentName: querentName, quesitedName: quesitedName)
            return PerfectionResult(
                isPerfected: true,
                type: .occupation,
                description: "A figura do Consulente (\(querentName)) está presente na Casa da Pergunta (Casa \(quesitedHouse)). Isso indica um 'Sim' forte e direto.",
                querentFigureName: querentName,
                quesitedFigureName: quesitedName,
                qualityAssessment: quality,
                querentAnswer: querentAnswer,
                quesitedAnswer: quesitedAnswer,
                conjunctionDetails: nil
            )
        }
        
        // 2. Conjunction: Check if figures pass to neighboring houses
        let hQNeighbors = getNeighbors(of: quesitedHouse)
        
        for n in hQNeighbors {
            if figurePattern(forHouse: n) == h1Pattern {
                let quality = assessQuality(querentAnswer: querentAnswer, quesitedAnswer: quesitedAnswer, querentName: querentName, quesitedName: quesitedName)
                let details = analyzeConjunction(passingHouse: querentHouse, targetHouse: quesitedHouse, passingToHouse: n, isQuerentPassing: true)
                return PerfectionResult(
                    isPerfected: true,
                    type: .conjunction,
                    description: "Conjunção do Consulente para o Quesito: A figura do Consulente (\(querentName)) passa para a Casa \(n), vizinha à Casa da Pergunta (\(quesitedHouse)).",
                    querentFigureName: querentName,
                    quesitedFigureName: quesitedName,
                    qualityAssessment: quality,
                    querentAnswer: querentAnswer,
                    quesitedAnswer: quesitedAnswer,
                    conjunctionDetails: details
                )
            }
        }
        
        
        let h1Neighbors = getNeighbors(of: querentHouse)
        for n in h1Neighbors {
            if figurePattern(forHouse: n) == hQPattern {
                let quality = assessQuality(querentAnswer: querentAnswer, quesitedAnswer: quesitedAnswer, querentName: querentName, quesitedName: quesitedName)
                let details = analyzeConjunction(passingHouse: quesitedHouse, targetHouse: querentHouse, passingToHouse: n, isQuerentPassing: false)
                return PerfectionResult(
                    isPerfected: true,
                    type: .conjunction,
                    description: "Conjunção do Quesito para o Consulente: A figura da Questão (\(quesitedName)) passa para a Casa \(n), vizinha à Casa do Consulente (1).",
                    querentFigureName: querentName,
                    quesitedFigureName: quesitedName,
                    qualityAssessment: quality,
                    querentAnswer: querentAnswer,
                    quesitedAnswer: quesitedAnswer,
                    conjunctionDetails: details
                )
            }
        }
        
        // 3. Mutation: Both significators appear as neighbors elsewhere
        // Scan all pairs of neighbors (1-2, 2-3... 12-1)
        for i in 1...12 {
            let neighbor = i == 12 ? 1 : i + 1
            let f1 = figurePattern(forHouse: i)
            let f2 = figurePattern(forHouse: neighbor)
            
            // Check matching pair (order doesn't matter)
            if (f1 == h1Pattern && f2 == hQPattern) || (f1 == hQPattern && f2 == h1Pattern) {
                let quality = assessQuality(querentAnswer: querentAnswer, quesitedAnswer: quesitedAnswer, querentName: querentName, quesitedName: quesitedName)
                return PerfectionResult(
                    isPerfected: true,
                    type: .mutation,
                    description: "As figuras do Consulente e da Questão se encontram vizinhas nas Casas \(i) e \(neighbor). Isso indica um encontro ou mudança de circunstância que une os dois.",
                    querentFigureName: querentName,
                    quesitedFigureName: quesitedName,
                    qualityAssessment: quality,
                    querentAnswer: querentAnswer,
                    quesitedAnswer: quesitedAnswer,
                    conjunctionDetails: nil
                )
            }
        }
        
        return PerfectionResult(
            isPerfected: false,
            type: .none,
            description: "Não foi encontrada nenhuma conexão direta (Ocupação, Conjunção ou Mutação) entre a Casa 1 e a Casa \(quesitedHouse). Isso geralmente indica um 'Não' ou falta de oportunidade.",
            querentFigureName: querentName,
            quesitedFigureName: quesitedName,
            qualityAssessment: nil,
            querentAnswer: querentAnswer,
            quesitedAnswer: quesitedAnswer,
            conjunctionDetails: nil
        )
    }
    
    // Helper to analyze conjunction details
    private func analyzeConjunction(passingHouse: Int, targetHouse: Int, passingToHouse: Int, isQuerentPassing: Bool) -> String {
        var details = ""
        
        // Determine who is doing the work
        if isQuerentPassing {
            details += "💪 O Consulente será a força principal para trazer o resultado, colocando mais trabalho.\n\n"
        } else {
            details += "🌟 O Consulente não precisará fazer muito, pois o lado do Quesito trabalhará mais para isso.\n\n"
        }
        
        // Determine timing (before = secret, after = open)
        let isBefore = (passingToHouse == (targetHouse == 1 ? 12 : targetHouse - 1))
        
        if isBefore {
            details += "🔒 Trabalho em segredo: O trabalho será feito por trás das costas, em segredo, ou sem o conhecimento da outra parte."
        } else {
            details += "👁️ Trabalho aberto: O trabalho será feito à vista clara, com conhecimento aberto, ou com aceitação e acordo entre as duas partes."
        }
        
        return details
    }
    
    // Helper to assess quality of a perfected reading
    private func assessQuality(querentAnswer: String?, quesitedAnswer: String?, querentName: String, quesitedName: String) -> String {
        // Check if either figure is unfavorable
        let unfavorableAnswers = ["Desfavorável", "Muito Desfavorável"]
        let favorableAnswers = ["Favorável", "Muito Favorável"]
        
        let querentUnfavorable = querentAnswer.map { unfavorableAnswers.contains($0) } ?? false
        let quesitedUnfavorable = quesitedAnswer.map { unfavorableAnswers.contains($0) } ?? false
        
        let querentFavorable = querentAnswer.map { favorableAnswers.contains($0) } ?? false
        let quesitedFavorable = quesitedAnswer.map { favorableAnswers.contains($0) } ?? false
        
        if querentUnfavorable || quesitedUnfavorable {
            if querentUnfavorable && quesitedUnfavorable {
                return "⚠️ Embora a resposta seja 'Sim', ambas as figuras (\(querentName) e \(quesitedName)) indicam aspectos desfavoráveis. O resultado pode ser negativo ou problemático."
            } else if quesitedUnfavorable {
                return "⚠️ A resposta é 'Sim', mas a figura na Casa da Pergunta (\(quesitedName)) é desfavorável. Há potencial para dificuldades ou resultados indesejados."
            } else {
                return "⚠️ A resposta é 'Sim', mas sua figura (\(querentName)) indica desafios. Proceda com cautela."
            }
        } else if querentFavorable && quesitedFavorable {
            return "✨ Excelente! Ambas as figuras são favoráveis. O 'Sim' indica um resultado muito positivo."
        } else if querentFavorable || quesitedFavorable {
            return "A resposta é 'Sim' com aspectos favoráveis, mas consulte as figuras da Corte para nuances adicionais."
        }
        
        return "A resposta é 'Sim'. Consulte as figuras envolvidas e a Corte para entender melhor a qualidade do resultado."
    }
    
    private func getNeighbors(of house: Int) -> [Int] {
        let prev = house == 1 ? 12 : house - 1
        let next = house == 12 ? 1 : house + 1
        return [prev, next]
    }
    
    private func areNeighbors(h1: Int, h2: Int) -> Bool {
        return getNeighbors(of: h1).contains(h2)
    }
    
    // MARK: - Export
    
    func exportReadingSummary() -> String {
        // Helper to get name
        func getName(for pattern: [Int]) -> String {
            return meaning(for: pattern)?.latinName.lowercased() ?? "unknown"
        }
        
        var parts: [String] = []
        
        // Mothers M1-M4
        for (i, m) in reading.mothers.enumerated() {
            parts.append("M\(i+1): \(getName(for: m))")
        }
        
        // Daughters F1-F4
        for (i, d) in reading.daughters.enumerated() {
            parts.append("F\(i+1): \(getName(for: d))")
        }
        
        // Nieces S1-S4
        for (i, n) in reading.nieces.enumerated() {
            parts.append("S\(i+1): \(getName(for: n))")
        }
        
        // Witnesses
        parts.append("TE: \(getName(for: reading.leftWitness))")
        parts.append("TD: \(getName(for: reading.rightWitness))")
        
        // Judge
        parts.append("Juiz: \(getName(for: reading.judge))")
        
        // Reconciler
        parts.append("Reconciliador: \(getName(for: reading.reconciler))")
        
        return parts.joined(separator: " ")
    }
}
