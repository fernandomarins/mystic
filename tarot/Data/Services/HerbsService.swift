//
//  HerbsService.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation

class HerbsService {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }
    
    func getHerbs() async throws -> Herbs {
        try await apiClient.request(.getHerbs)
    }
}
