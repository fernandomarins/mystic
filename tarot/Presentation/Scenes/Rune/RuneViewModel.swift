//
//  RuneViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation
import SwiftData

@MainActor
class RuneViewModel: ObservableObject {
    @Published var runes: [RuneModel] = []
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    private let repository: RunesRepository
    
    init(repository: RunesRepository = RunesRepository()) {
        self.repository = repository
    }
    
    func fetchRunes(context: ModelContext) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            runes = try await repository.fetchRunes(context: context)
        } catch {
            errorMessage = IdentifiableError(message: "Failed to fetch runes: \(error.localizedDescription)")
        }
    }
}
