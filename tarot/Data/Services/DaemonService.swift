//
//  DaemonService.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation

class DaemonService {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }
    
    func getDaemons() async throws -> [DaemonModel] {
        try await apiClient.request(.getDaemons)
    }
}
