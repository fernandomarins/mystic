//
//  SangomaViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation

@MainActor
class SangomaViewModel: ObservableObject {
    @Published var sangoma: SangomaModel = SangomaModel(bones: [], buzios: [])
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    private let service: SangomaService
    
    init(service: SangomaService = SangomaService()) {
        self.service = service
    }
    
    func fetchSangoma() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            sangoma = try await service.getSangoma()
        } catch {
            errorMessage = IdentifiableError(message: "Failed to fetch sangoma: \(error.localizedDescription)")
        }
    }
}
