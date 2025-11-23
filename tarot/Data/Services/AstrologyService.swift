//
//  AstrologyService.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation

class AstrologyService {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }
    
    func getAstrology() async throws -> AstrologyModel {
        try await apiClient.request(.getAstrology)
    }
}
