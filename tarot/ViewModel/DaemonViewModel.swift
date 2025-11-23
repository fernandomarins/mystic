//
//  DaemonViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation

@MainActor
class DaemonViewModel: ObservableObject {
    @Published var daemons: [DaemonModel] = []
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    func fetchDaemons() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            daemons = try await service.getDaemons()
        } catch {
            errorMessage = IdentifiableError(message: "Failed to fetch daemons: \(error.localizedDescription)")
        }
    }
}
