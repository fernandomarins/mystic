//
//  PontosRiscadosViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 26/12/24.
//

import Foundation

@MainActor
class PontosRiscadosViewModel: ObservableObject {
    @Published var pontos: [PontoRiscado] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchPontos() {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = Bundle.main.url(forResource: "pontos", withExtension: "json") else {
            errorMessage = "Arquivo pontos.json não encontrado."
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(PontosResponse.self, from: data)
            pontos = response.pontos_espirituais
        } catch {
            errorMessage = "Erro ao decodificar pontos.json: \(error.localizedDescription)"
            print("Decoding error: \(error)")
        }
    }
}
