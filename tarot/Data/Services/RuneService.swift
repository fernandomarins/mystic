//
//  RuneService.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation

class RuneService {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }
    
    func getRunes() async throws -> [RuneModel] {
        try await apiClient.request(.getRunes)
    }
}
