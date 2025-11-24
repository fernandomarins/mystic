//
//  TreeViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 24/11/24.
//

import Foundation

@MainActor
class TreeViewModel: ObservableObject {
    @Published var treeData: TreeModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchTreeData() {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = Bundle.main.url(forResource: "tree", withExtension: "json") else {
            errorMessage = "Arquivo tree.json não encontrado."
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            treeData = try decoder.decode(TreeModel.self, from: data)
        } catch {
            errorMessage = "Erro ao decodificar tree.json: \(error.localizedDescription)"
        }
    }
}
