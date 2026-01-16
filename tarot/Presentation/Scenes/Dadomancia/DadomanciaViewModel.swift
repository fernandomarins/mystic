//
//  DadomanciaViewModel.swift
//  tarot
//
//  Created by Antigravity on 10/01/26.
//

import Foundation

@MainActor
class DadomanciaViewModel: ObservableObject {
    @Published var meanings: [DadomanciaMeaning] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchMeanings() {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = Bundle.main.url(forResource: "dadomancia", withExtension: "json") else {
            errorMessage = "Arquivo dadomancia.json não encontrado no Bundle."
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(DadomanciaResponse.self, from: data)
            meanings = response.meanings
        } catch {
            errorMessage = "Erro ao decodificar dadomancia.json: \(error.localizedDescription)"
            print("Decoding error: \(error)")
        }
    }
}
