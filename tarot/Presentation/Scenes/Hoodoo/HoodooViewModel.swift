//
//  HoodooViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation

@MainActor
class HoodooViewModel: ObservableObject {
    @Published var hoodoo: HoodooModel? = nil
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    func fetchHoodoo() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            hoodoo = try await service.getHoodoo()
        } catch {
            errorMessage = IdentifiableError(message: "Failed to fetch hoodoo: \(error.localizedDescription)")
        }
    }
}
