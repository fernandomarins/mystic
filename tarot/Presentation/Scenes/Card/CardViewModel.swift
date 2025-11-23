//
//  CardViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation

@MainActor
class CardViewModel: ObservableObject {
    @Published var cards: [CardModel] = []
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    func fetchCards() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            cards = try await service.getCards()
        } catch {
            errorMessage = IdentifiableError(message: "Failed to fetch cards: \(error.localizedDescription)")
        }
    }
}
