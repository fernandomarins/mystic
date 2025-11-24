//
//  DaemonViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation
import SwiftData

@MainActor
class DaemonViewModel: ObservableObject {
    @Published var daemons: [DaemonModel] = []
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    private let repository: DaemonsRepository
    
    init(repository: DaemonsRepository = DaemonsRepository()) {
        self.repository = repository
    }
    
    func fetchDaemons(context: ModelContext) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            daemons = try await repository.fetchDaemons(context: context)
        } catch {
            errorMessage = IdentifiableError(message: "Failed to fetch daemons: \(error.localizedDescription)")
        }
    }
}
