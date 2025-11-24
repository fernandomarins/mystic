//
//  SangomaService.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation

class SangomaService {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }
    
    func getSangoma() async throws -> SangomaModel {
        try await apiClient.request(.getSangoma)
    }
}
