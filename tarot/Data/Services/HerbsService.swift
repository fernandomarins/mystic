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
    
    func postHerb(_ herb: Herb) async throws -> Herb {
        try await apiClient.post(.postHerb, body: herb)
    }
}
