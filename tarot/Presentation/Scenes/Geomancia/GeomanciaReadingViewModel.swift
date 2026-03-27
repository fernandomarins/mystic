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
    @Published var highlightedPattern: [Int]? = nil
    
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
        let exampleQuestions: [String]?
    }
    
    let housesData: [HouseDefinition] = [
        HouseDefinition(id: 1, name: "Casa 1 (I - Vita): A Vida", icon: "🏹", description: "Tradicionalmente representa o consulente, a pessoa sobre a qual a adivinhação é realizada. Em leituras de nascimento, períodos (dias, anos) ou personalidade, mostra o temperamento e a condição geral do indivíduo. No mapa padrão das casas, é o ponto de partida que identifica você, enquanto o objetivo da sua pergunta (o quesito) será encontrado em outra casa.", quality: "Angular (Forte/Rápida)", exampleQuestions: [
            "Qual é o meu estado atual nesta situação?",
            "Como minha personalidade está afetando o problema?",
            "Qual é a minha disposição física e mental agora?",
            "Quem sou eu nesta situação?"
        ]),
        HouseDefinition(id: 2, name: "Casa 2 (II - Lucrum): O Lucro", icon: "💰", description: "A segunda casa governa tradicionalmente o dinheiro e bens móveis. Qualquer questão relacionada a lucro e perda, renda, investimentos, pertences pessoais, roubos e afins toma a figura na segunda casa como significadora do quesito. As exceções a esta regra são bens imóveis (que pertencem à quarta casa) e investimentos especulativos (que pertencem à quinta).", quality: "Sucedente (Moderada/Estável)", exampleQuestions: [
            "Meu negócio vai dar lucro ou prejuízo?",
            "O investimento será rentável?",
            "Serei pago pelo trabalho que fiz?",
            "Este é um bom momento para pedir dinheiro emprestado?",
            "A mesa antiga vale o que o vendedor está pedindo?",
            "O pacote que enviei chegará com segurança?",
            "Meu relógio desaparecido foi roubado?",
            "Meu carro roubado será recuperado?"
        ]),
        HouseDefinition(id: 3, name: "Casa 3 (III - Fratres): Os Irmãos", icon: "🧠", description: "Governa tradicionalmente os irmãos e irmãs do consulente, vizinhos e o ambiente imediato. Também rege jornadas de menos de 300 km (200 milhas), educação do pré-escolar ao ensino médio, conselhos, notícias e boatos.", quality: "Cadente (Fraca/Atrasos)", exampleQuestions: [
            "Meu relacionamento com minha irmã vai melhorar?",
            "Os vizinhos concordarão com a servidão de passagem?",
            "Este é um bom fim de semana para dirigir até a praia?",
            "Devo matricular meu filho na North Central Elementary?",
            "Vale a pena seguir o conselho do meu vizinho George?",
            "A notícia é precisa?",
            "Devo acreditar nos boatos?"
        ]),
        HouseDefinition(id: 4, name: "Casa 4 (IV - Genitor): O Pai", icon: "🏠", description: "Governa tradicionalmente a terra, agricultura, construção, cidades e vilas, relocalização e mudança, qualquer coisa subterrânea, qualquer objeto desconhecido, lugares e coisas antigas, velhice, o pai do consulente e o fim de qualquer assunto.", quality: "Angular (Forte/Rápida)", exampleQuestions: [
            "Vale a pena comprar a propriedade?",
            "O solo é fértil?",
            "As rosas vão florescer aqui?",
            "Devo me mudar para outro apartamento?",
            "Springfield é um bom lugar para se mudar?",
            "A mesa é antiga ou uma reprodução moderna?",
            "O fundo de pensão está em mãos confiáveis?",
            "Como está meu pai?",
            "Como a situação atual terminará no final?"
        ]),
        HouseDefinition(id: 5, name: "Casa 5 (V - Nati): Os Filhos", icon: "❤️", description: "Governa tradicionalmente as safras de plantas perenes ou bienais, fertilidade, gravidez e crianças. A sexualidade pertence aqui, mas não o amor ou o casamento (que são da sétima). Festas, entretenimento de todos os tipos, comida, bebida e roupas também pertencem à quinta casa, junto com massas de água, pesca e chuva. Por fim, cartas, mensagens e livros pertencem aqui; na Idade Média, era comum perguntar se um livro continha informações precisas — algo muito útil hoje em dia.", quality: "Sucedente (Moderada/Estável)", exampleQuestions: [
            "A safra de uvas será boa este ano?",
            "Janis está interessada em mim sexualmente?",
            "Meu filho ainda não nascido é menino ou menina?",
            "Como meu filho de quatro anos lidará com um irmãozinho?",
            "O show valerá o preço do ingresso?",
            "Sexta-feira que vem é uma boa noite para a festa?",
            "O novo restaurante asiático da cidade vale a visita?",
            "O vestido ficará pronto a tempo para o casamento?",
            "Como será a pesca no lago este fim de semana?",
            "Vai chover amanhã?",
            "Receberei uma carta da minha avó?",
            "As afirmações no livro que estou lendo são precisas?"
        ]),
        HouseDefinition(id: 6, name: "Casa 6 (VI - Valetudo): A Saúde", icon: "⚙️", description: "Governa tradicionalmente os funcionários do consulente e pessoas em todas as profissões de serviço, de médicos a encanadores, artistas e profissionais do sexo. Governa praticantes de magia e ocultismo que não sejam o consulente. Também rege animais de estimação e todos os animais domésticos (exceto cavalos, burros, mulas e camelos). Por fim, governa doenças e ferimentos.", quality: "Cadente (Fraca/Atrasos)", exampleQuestions: [
            "Devo contratar Phyllis?",
            "Meus funcionários estão roubando do caixa?",
            "Os encanadores são confiáveis?",
            "Devo contratar uma banda para a festa?",
            "Vou encontrar meu cachorro perdido?",
            "Os porcos terão um bom preço neste outono?",
            "Quão grave é esta doença?",
            "Valeria a pena fazer uma leitura de Tarot com Marie?",
            "Este é um bom momento para fazer um tratamento dentário?",
            "Vou pegar gripe neste inverno?"
        ]),
        HouseDefinition(id: 7, name: "Casa 7 (VII - Uxor): O Cônjuge", icon: "🤝", description: "Governa as relações humanas mais intensas. O cônjuge ou amante do consulente pertence aqui, junto com tudo relacionado ao amor e casamento. Parcerias, acordos e tratados também pertencem à sétima casa, junto com toda forma de conflito e competição, do beisebol à guerra nuclear. Ladrões pertencem à sétima, assim como inimigos conhecidos. Caça, localização de pessoas e médicos (em divinação médica) também são da sétima casa.", quality: "Angular (Forte/Rápida)", exampleQuestions: [
            "Stanley me ama?",
            "Este relacionamento vai durar?",
            "Este é um bom momento para propor casamento?",
            "Eu e Carol devemos formar uma parceria comercial?",
            "Devo assinar o contrato?",
            "O time vencerá o campeonato?",
            "Os países assinarão o tratado de paz?",
            "A proposta da minha empresa para o projeto será aceita?",
            "Seria vantajoso para mim abrir um processo?",
            "A polícia pegará o ladrão?",
            "O próximo fim de semana é bom para caçar?",
            "Poderei entrar em contato com Julie novamente?"
        ]),
        HouseDefinition(id: 8, name: "Casa 8 (VIII - Mors): A Morte", icon: "☠️", description: "Governa tradicionalmente a morte e tudo o que se relaciona a ela. Rege questões sobre fantasmas e todas as outras entidades espirituais. Também abrange a magia realizada pelo próprio consulente, ou em seu benefício (enquanto a adivinhação e a filosofia oculta pertencem à nona). Governa a condição de pessoas ausentes ou desaparecidas, e dinheiro ou propriedade que o consulente emprestou a terceiros.", quality: "Sucedente (Moderada/Estável)", exampleQuestions: [
            "Devo fazer um seguro de vida?",
            "Quão a sério devo levar as ameaças de Bill?",
            "Este é um bom momento para fazer um testamento?",
            "A casa está realmente assombrada?",
            "O trabalho mágico que estou planejando é apropriado?",
            "A filha desaparecida do meu vizinho está bem?",
            "Vou recuperar o livro que emprestei para o Greg?"
        ]),
        HouseDefinition(id: 9, name: "Casa 9 (IX - Iter): As Viagens", icon: "🌍", description: "Governa tradicionalmente longas jornadas de todos os tipos, exteriores e interiores. Viagens de mais de 300 km, viagens marítimas, aéreas e espaciais. Também rege a religião e espiritualidade, ensino superior, artes e interpretação de sonhos. A filosofia oculta e a adivinhação, como algo distinto das práticas mágicas (que pertencem à oitava), também residem aqui.", quality: "Cadente (Fraca/Atrasos)", exampleQuestions: [
            "Poderei ir para a Alemanha este verão?",
            "Quão congestionado estará o aeroporto?",
            "Devo seguir meu interesse na religião pagã?",
            "Conseguirei entrar naquela universidade?",
            "É um bom momento para voltar a estudar e terminar minha graduação?",
            "Devo começar aulas de música, ou estaria perdendo tempo?",
            "O sonho que tive ontem à noite significa alguma coisa?",
            "Devo estudar geomancia?"
        ]),
        HouseDefinition(id: 10, name: "Casa 10 (X - Regnum): O Reino", icon: "👑", description: "Governa a carreira, reputação e posição social do consulente. Representa pessoas em posições de autoridade e a mãe do consulente. A política pertence a esta casa, desde o conselho escolar local até as Nações Unidas. Também rege o estado do tempo (clima). Na divinação médica, governa o tratamento prescrevido.", quality: "Angular (Forte/Rápida)", exampleQuestions: [
            "Devo procurar um emprego diferente?",
            "Receberei a promoção?",
            "Vou me dar bem com meu novo chefe?",
            "O escritório do condado aprovará minha licença de construção?",
            "Como mamãe tem passado ultimamente?",
            "O senador vencerá a reeleição?",
            "Devo me candidatar a uma vaga no conselho escolar?",
            "O tempo amanhã estará limpo e seco?",
            "Devo pedir uma segunda opinião sobre o tratamento proposto?"
        ]),
        HouseDefinition(id: 11, name: "Casa 11 (XI - Benefacta): Os Amigos", icon: "🧑‍🤝‍🧑", description: "Governa tradicionalmente amigos, associados, promessas, fontes de ajuda e as esperanças e desejos do consulente. Também rege safras de plantas anuais e qualquer pergunta que o consulente não queira revelar ao divindade.", quality: "Sucedente (Moderada/Estável)", exampleQuestions: [
            "Como está meu velho amigo de faculdade, Bill?",
            "Minha amiga Sally cumprirá sua promessa?",
            "Posso contar com o apoio da associação de moradores?",
            "Alcançarei meu sonho mais profundo?",
            "Terei uma boa colheita de ervilhas este ano?",
            "Não quero dizer qual é minha pergunta — você pode respondê-la de qualquer maneira?"
        ]),
        HouseDefinition(id: 12, name: "Casa 12 (XII - Carcer): A Prisão", icon: "🌑", description: "Governa tradicionalmente as partes menos agradáveis da vida, incluindo restrições e limitações, dívidas do consulente, prisão, qualquer coisa secreta e inimigos que o consulente desconhece. Magia feita por outra pessoa para prejudicar o consulente pertence aqui. Também governa gado, cavalos, burros, mulas, camelos e todos os animais selvagens.", quality: "Cadente (Fraca/Atrasos)", exampleQuestions: [
            "Poderei pagar minhas contas no próximo mês?",
            "Serei enviado para a prisão?",
            "Ruth está escondendo algo de mim?",
            "Alguém no trabalho está tentando me fazer ser demitido?",
            "O objeto no jardim era uma piada ou alguém tentou lançar um feitiço?",
            "Este cavalo vale a pena ser comprado?",
            "O gado terá um bom preço este ano?"
        ])
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
