//
//  ElementsViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 24/11/24.
//

import Foundation

@MainActor
class ElementsViewModel: ObservableObject {
    @Published var elements: ElementsModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchElements() {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = Bundle.main.url(forResource: "elements", withExtension: "json") else {
            errorMessage = "Arquivo elements.json não encontrado."
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            elements = try decoder.decode(ElementsModel.self, from: data)
        } catch {
            errorMessage = "Erro ao decodificar elements.json: \(error.localizedDescription)"
        }
    }
}
