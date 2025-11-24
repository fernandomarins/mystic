//
//  CardViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation
import SwiftData

@MainActor
class CardViewModel: ObservableObject {
    @Published var cards: [CardModel] = []
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    private let repository: CardRepository
    
    init(repository: CardRepository = CardRepository()) {
        self.repository = repository
    }
    
    func fetchCards(context: ModelContext) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            cards = try await repository.fetchCards(context: context)
        } catch {
            errorMessage = IdentifiableError(message: "Failed to fetch cards: \(error.localizedDescription)")
        }
    }
}
