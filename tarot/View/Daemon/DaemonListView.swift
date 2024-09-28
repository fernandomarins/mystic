//
//  DaemonListView.swift
//  tarot
//
//  Created by Fernando Marins on 19/09/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct DaemonListView: View {
    @StateObject private var viewModel = ViewModel(service: Service())
    @State private var searchResults: [DaemonModel] = []
    @State private var searchQuery: String = ""
    @State private var isSearching: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    LoadingIndicator(
                        animation: .circleBars,
                        color: .white,
                        size: .medium
                    )
                } else {
                    List {
                        let displayedDaemons = isSearching ? searchResults : viewModel.daemons
                        ForEach(displayedDaemons) { daemon in
                            NavigationLink(destination: DaemonView(daemon: daemon)) {
                                Text("\(daemon.id) - \(daemon.name)")
                            }
                        }
                    }
                    .navigationTitle("Daemons")
                    .refreshable {
                        Task {
                            await viewModel.fetchDaemons()
                        }
                    }
                    .searchable(
                        text: $searchQuery,
                        placement: .automatic,
                        prompt: "Daemon"
                    )
                    .textInputAutocapitalization(.never)
                    .onChange(of: searchQuery) { newValue, _ in
                        if newValue.isEmpty {
                            isSearching = false
                        } else {
                            isSearching = true
                            fetchSearchResults(for: newValue)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .onAppear {
                if viewModel.daemons.isEmpty {
                    Task {
                        await viewModel.fetchDaemons()
                    }
                }
            }
        }
        .toolbar {
            daemonTypeOptions
        }
    }
    
    @ToolbarContentBuilder
    private var daemonTypeOptions: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu("Selecione uma especialidade", systemImage: "arrow.up.arrow.down") {
                ForEach(DaemonType.allCases, id: \.self) { type in
                    Button(type.rawValue) {
                        searchResults = selectedDaemon(for: type)
                        isSearching = true
                    }
                }
            }
        }
    }
    
    private func fetchSearchResults(for query: String) {
        let queryLowercased = query.lowercased()
        
        searchResults = viewModel.daemons.filter { rune in
            rune.name.lowercased().contains(queryLowercased)
        }
    }
    
    private enum DaemonType: String, CaseIterable {
        case todos = "Todos"
        case adivinhacao = "Adivinhação"
        case afogamento = "Afogamento"
        case amizades = "Amizades"
        case amizadeObtençãoEReconciliacao = "Amizade (obtenção & reconciliação)"
        case amor = "Amor"
        case animais = "Animais"
        case aritmetica = "Aritmética"
        case artesLiberaisECiencias = "Artes liberais & ciências"
        case astrologia = "Astrologia"
        case astronomia = "Astronomia"
        case ataqueEDefesa = "Ataque e Defesa"
        case carismaTalentoHumor = "Carisma / Talento / Humor"
        case carismaInteligenciaHumorECoragem = "Carisma, inteligência, humor e coragem"
        case clarividencia = "Clarividência"
        case coisasPassadasPresenteEFuturoDeclarado = "Coisas passadas, presente & futuro declarado"
        case controleMental = "Controle mental"
        case construirTorresDefesas = "Construir torres (defesas)"
        case destruicaoPorFogo = "Destruição por fogo"
        case dinheiroVerTambemEncontrarTesouros = "Dinheiro (ver também Encontrar Tesouros)"
        case destruicaoDeInimigos = "Destruição de inimigos"
        case decisoes = "Decisões"
        case dinheiro = "Dinheiro"
        case divinacao = "Divinação"
        case encontrarTesouros = "Encontrar tesouros"
        case ervas = "Ervas"
        case ervasVirtudes = "Ervas (virtudes)"
        case espiritosFamiliares = "Espíritos familiares"
        case etica = "Ética"
        case filosofia = "Filosofia"
        case fornecemFamiliares = "Fornecem familiares"
        case geometria = "Geometria"
        case geomancia = "Geomancia"
        case gramatica = "Gramática"
        case hidromancia = "Hidromancia"
        case honrasPromocoesEPreferencias = "Honras, promoções & preferências"
        case honrasStatusEPromocoes = "Honras / Status / Promoções"
        case imobilizar = "Imobilizar"
        case infertilidade = "Infertilidade"
        case intelectoSabedoriaConhecimento = "Intelecto / Sabedoria / Conhecimento"
        case invisibilidade = "Invisibilidade"
        case linguas = "Línguas"
        case logica = "Lógica"
        case magos = "Magos"
        case militares = "Militares"
        case musica = "Música"
        case necromancia = "Necromancia"
        case negociosAjudaNoTrabalhoOuConseguirEmprego = "Negócios / Ajuda no trabalho / Conseguir emprego"
        case numerosSorte = "Números / Sorte"
        case ocultismo = "Ocultismo"
        case passadoPresente = "Passado / Presente"
        case pedras = "Pedras"
        case piromancia = "Piromancia"
        case perguntasERespostas = "Perguntas & respostas"
        case persuadirPessoas = "Persuadir Pessoas"
        case poderSobreAnimais = "Poder sobre animais"
        case poderValor = "Poder / Valor"
        case poesia = "Poesia"
        case policiaEQuestõesJudiciais = "Polícia & questões judiciais"
        case possessoes = "Possessões"
        case preverOFuturo = "Prever o futuro"
        case problemasComAlcoolEDrogasCuraVicios = "Problemas com álcool e drogas / Cura vícios"
        case processosLegaisJudiciais = "Processos legais (judiciais)"
        case protecaoEBravura = "Proteção e bravura"
        case protecaoFisicaESpiritual = "Proteção física e espiritual"
        case questoesRespondidasComSinceridade = "Questões respondidas com sinceridade"
        case quiromancia = "Quiromancia"
        case rebaixamentoDestruicaoDeHonras = "Rebaixamento, destruição de honras"
        case recuperandoCoisasPerdidasOuRoubadas = "Recuperando coisas perdidas ou roubadas"
        case reorganizandoCemiterios = "Reorganizando cemitérios"
        case sabedoria = "Sabedoria"
        case saudeSaudeComprometida = "Saúde, saúde comprometida"
        case saudeECura = "Saúde & cura"
        case segredosRevelados = "Segredos revelados"
        case terremotos = "Terremotos"
        case transmutacao = "Transmutação"
        case transformacoesMudancaDeForma = "Transformações, mudança de forma"
        case transporteViagens = "Transporte / Viagens"
        case viagemEProjecaoAstral = "Viagem / Projeção Astral"
    }

    
    private func selectedDaemon(for type: DaemonType) -> [DaemonModel] {
        let daemonIDs: [Int]
        
        switch type {
        case .todos:
            daemonIDs = viewModel.daemons.map { $0.id }
        case .afogamento:
            daemonIDs = [41, 42]
        case .animais:
            daemonIDs = [24, 53, 62]
        case .amizades:
            daemonIDs = [7, 8, 11, 17, 25, 27, 30, 40, 47, 55, 59, 68]
        case .amor:
            daemonIDs = [6, 7, 12, 13, 14, 15, 16, 19, 25, 29, 30, 32, 33, 34, 40, 47, 56, 71]
        case .aritmetica:
            daemonIDs = [32, 13]
        case .artesLiberaisECiencias:
            daemonIDs = [4, 9, 21, 24, 25, 29, 32, 33, 37, 46, 48, 49, 57, 58, 60, 71]
        case .astrologia:
            daemonIDs = [21, 46, 50, 58, 59]
        case .astronomia:
            daemonIDs = [21, 32, 36, 50, 52, 65]
        case .ataqueEDefesa:
            daemonIDs = [14, 15, 25, 35, 38, 41, 43]
        case .carismaInteligenciaHumorECoragem:
            daemonIDs = [22, 23, 51, 61]
        case .coisasPassadasPresenteEFuturoDeclarado:
            daemonIDs = [3, 7, 8, 11, 15, 17, 20, 22, 25, 26, 28, 29, 33, 40, 45, 47, 51, 55, 56, 64]
        case .controleMental:
            daemonIDs = [71]
        case .construirTorresDefesas:
            daemonIDs = [38, 39, 43, 45, 40, 41, 42, 44, 64]
        case .destruicaoPorFogo:
            daemonIDs = [26, 56]
        case .dinheiroVerTambemEncontrarTesouros:
            daemonIDs = [3, 7, 8, 11, 15, 17, 20, 22, 25, 26, 28, 29, 33, 40, 45, 47, 51, 55, 56, 64]
        case .destruicaoDeInimigos:
            daemonIDs = [8, 20, 31, 32, 40, 56, 58, 62, 66, 70, 72]
        case .divinacao:
            daemonIDs = []
        case .encontrarTesouros:
            daemonIDs = []
        case .ervasVirtudes:
            daemonIDs = [10, 17, 18, 21, 31, 36]
        case .espiritosFamiliares:
            daemonIDs = [9, 10, 20, 21, 33, 39, 43, 44, 52, 58, 67, 68]
        case .etica:
            daemonIDs = [31]
        case .filosofia:
            daemonIDs = [10, 33, 50, 54, 60]
        case .geometria:
            daemonIDs = [32, 46, 49, 65]
        case .gramatica:
            daemonIDs = [66]
        case .honrasPromocoesEPreferencias:
            daemonIDs = [9, 11, 15, 24, 28, 30, 55, 59, 68]
        case .imobilizar:
            daemonIDs = [2]
        case .infertilidade:
            daemonIDs = [16]
        case .invisibilidade:
            daemonIDs = [1, 25, 31, 51]
        case .linguas:
            daemonIDs = [2, 27, 30, 53]
        case .logica:
            daemonIDs = [10, 31, 50, 66]
        case .musica:
            daemonIDs = [6, 37, 67]
        case .poderSobreAnimais:
            daemonIDs = [8]
        case .poesia:
            daemonIDs = [37]
        case .protecaoEBravura:
            daemonIDs = []
        case .questoesRespondidasComSinceridade:
            daemonIDs = [3, 11, 20, 23, 26, 29, 32, 34, 35, 55, 57]
        case .rebaixamentoDestruicaoDeHonras:
            daemonIDs = []
        case .recuperandoCoisasPerdidasOuRoubadas:
            daemonIDs = [24, 27, 30, 32, 50, 51, 66]
        case .reorganizandoCemiterios:
            daemonIDs = [26, 46]
        case .sabedoria:
            daemonIDs = []
        case .saudeSaudeComprometida:
            daemonIDs = [14, 43, 44]
        case .segredosRevelados:
            daemonIDs = [3, 5, 15, 20, 29, 34, 56, 57, 71]
        case .terremotos:
            daemonIDs = [2]
        case .transmutacao:
            daemonIDs = [28, 48, 61]
        case .transformacoesMudancaDeForma:
            daemonIDs = [5, 57, 59, 65]
        case .transporteViagens:
            daemonIDs = [18]
        case .problemasComAlcoolEDrogasCuraVicios:
            daemonIDs = [10]
        case .viagemEProjecaoAstral:
            daemonIDs = [1, 18, 32, 33, 51]
        case .perguntasERespostas:
            daemonIDs = [3, 11, 20, 29, 32, 35, 37, 55, 57]
        case .negociosAjudaNoTrabalhoOuConseguirEmprego:
            daemonIDs = [9, 11, 15, 26, 55, 60, 62, 68, 70]
        case .carismaTalentoHumor:
            daemonIDs = [22, 31, 51, 61]
        case .clarividencia:
            daemonIDs = [29, 32, 50]
        case .decisoes:
            daemonIDs = [1, 17, 26]
        case .fornecemFamiliares:
            daemonIDs = [9, 10, 20, 21, 33, 39, 43, 44, 52, 58, 67, 68, 69]
        case .preverOFuturo:
            daemonIDs = [3, 7, 8, 11, 20, 22, 28, 29, 45, 47, 51, 55, 64]
        case .amizadeObtençãoEReconciliacao:
            daemonIDs = [7, 8, 11, 17, 22, 29, 62]
        case .possessoes:
            daemonIDs = [32]
        case .saudeECura:
            daemonIDs = [5, 6, 10]
        case .ervas:
            daemonIDs = [18, 21, 31, 36, 46, 69]
        case .honrasStatusEPromocoes:
            daemonIDs = [9, 11, 28, 29, 30, 55, 68]
        case .intelectoSabedoriaConhecimento:
            daemonIDs = [1, 5, 6, 25, 26, 29, 48, 49, 51, 60, 61]
        case .processosLegaisJudiciais:
            daemonIDs = [15]
        case .militares:
            daemonIDs = [15, 43, 42, 66]
        case .dinheiro:
            daemonIDs = [26, 40, 58, 72]
        case .necromancia:
            daemonIDs = [4, 24, 26, 46, 54, 58]
        case .numerosSorte:
            daemonIDs = [62]
        case .passadoPresente:
            daemonIDs = [3, 7, 8, 11, 17, 20, 22, 25, 28, 33, 45, 47, 51, 55, 56, 64]
        case .policiaEQuestõesJudiciais:
            daemonIDs = [15]
        case .magos:
            daemonIDs = [2, 6, 21, 33, 39, 45, 46, 55, 62, 64, 70]
        case .pedras:
            daemonIDs = [18,21,24,31,36,46,69]
        case .poderValor:
            daemonIDs = [17, 22, 35]
        case .adivinhacao:
            daemonIDs = [66]
        case .geomancia:
            daemonIDs = [32]
        case .hidromancia:
            daemonIDs = [53]
        case .ocultismo:
            daemonIDs = [25]
        case .quiromancia:
            daemonIDs = [50]
        case .piromancia:
            daemonIDs = [50]
        case .protecaoFisicaESpiritual:
            daemonIDs = [45, 55, 66]
        case .persuadirPessoas:
            daemonIDs = [32, 68, 71]
        }
        
        // Filtra os modelos de demônios a partir do array viewModel.daemons
        return viewModel.daemons.filter { daemonIDs.contains($0.id) }
    }

}

#Preview {
    DaemonListView()
}
