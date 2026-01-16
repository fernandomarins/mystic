//
//  GeomanciaViewModel.swift
//  tarot
//
//  Created by Antigravity on 15/01/26.
//

import Foundation

class GeomanciaViewModel: ObservableObject {
    @Published var forms: [GeomanciaMeaning] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchForms() {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = Bundle.main.url(forResource: "geomancia", withExtension: "json") else {
            errorMessage = "Arquivo geomancia.json não encontrado."
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(GeomanciaResponse.self, from: data)
            forms = response.forms
        } catch {
            errorMessage = "Erro ao decodificar geomancia.json: \(error.localizedDescription)"
            print("Decoding error: \(error)")
        }
    }
}
