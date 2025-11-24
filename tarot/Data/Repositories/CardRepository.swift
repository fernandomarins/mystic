//
//  CardRepository.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation
import SwiftData

class CardRepository {
    private let service: CardService
    
    init(service: CardService = CardService()) {
        self.service = service
    }
    
    @MainActor
    func fetchCards(context: ModelContext) async throws -> [CardModel] {
        // 1. Try to fetch from local database
        let descriptor = FetchDescriptor<CardEntity>(sortBy: [SortDescriptor(\.id)])
        let localCards = try context.fetch(descriptor)
        
        if !localCards.isEmpty {
            return localCards.map { $0.toModel() }
        }
        
        // 2. If empty, fetch from API
        let remoteCards = try await service.getCards()
        
        // 3. Save to local database
        for card in remoteCards {
            let entity = CardEntity(card: card)
            context.insert(entity)
        }
        
        // 4. Return remote cards
        return remoteCards
    }
}
