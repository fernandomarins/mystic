//
//  CardService.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation

class CardService {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }
    
    func getCards() async throws -> [CardModel] {
        try await apiClient.request(.getCards)
    }
}
