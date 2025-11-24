//
//  HerbsViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation
import SwiftData

@MainActor
class HerbsViewModel: ObservableObject {
    @Published var herbs: [Herb] = []
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    private let repository: HerbsRepository
    
    init(repository: HerbsRepository = HerbsRepository()) {
        self.repository = repository
    }
    
    func fetchHerbs(context: ModelContext) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            herbs = try await repository.fetchHerbs(context: context)
        } catch {
            errorMessage = IdentifiableError(message: "Failed to fetch herbs: \(error.localizedDescription)")
        }
    }
    
    func getHerbType(type: HerbType) -> [Herb] {
        herbs.filter { $0.type == type }
    }
}
