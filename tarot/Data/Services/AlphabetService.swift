//
//  AlphabetService.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation

class AlphabetService {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }
    
    func getAlphabet() async throws -> [LetterModel] {
        try await apiClient.request(.getAlphabet)
    }
}
