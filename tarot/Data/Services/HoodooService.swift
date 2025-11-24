//
//  HoodooService.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation

class HoodooService {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }
    
    func getHoodoo() async throws -> HoodooModel {
        try await apiClient.request(.getHooboo)
    }
}
