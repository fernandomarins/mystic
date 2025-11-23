//
//  AstrologyViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation

@MainActor
class AstrologyViewModel: ObservableObject {
    @Published var astrology: AstrologyModel? = nil
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    func fetchAstrology() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            astrology = try await service.getAstrology()
        } catch {
            errorMessage = IdentifiableError(message: "Failed to fetch astrology: \(error.localizedDescription)")
        }
    }
}
