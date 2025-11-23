//
//  AlphabetViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation

@MainActor
class AlphabetViewModel: ObservableObject {
    @Published var alphabet: [LetterModel] = []
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    func fetchAlphabet() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            alphabet = try await service.getAlphabet()
        } catch {
            errorMessage = IdentifiableError(message: "Failed to fetch alphabet: \(error.localizedDescription)")
        }
    }
}
