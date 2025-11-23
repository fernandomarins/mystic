//
//  RuneViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation

@MainActor
class RuneViewModel: ObservableObject {
    @Published var runes: [RuneModel] = []
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    private let service: RuneService
    
    init(service: RuneService = RuneService()) {
        self.service = service
    }
    
    func fetchRunes() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            runes = try await service.getRunes()
        } catch {
            errorMessage = IdentifiableError(message: "Failed to fetch runes: \(error.localizedDescription)")
        }
    }
}
