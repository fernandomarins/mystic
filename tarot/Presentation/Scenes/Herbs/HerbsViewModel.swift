//
//  HerbsViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation

@MainActor
class HerbsViewModel: ObservableObject {
    @Published var herbs: [Herb] = []
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    private let service: HerbsService
    
    init(service: HerbsService = HerbsService()) {
        self.service = service
    }
    
    func fetchHerbs() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await service.getHerbs()
            herbs = response.herbs
        } catch {
            errorMessage = IdentifiableError(message: "Failed to fetch herbs: \(error.localizedDescription)")
        }
    }
    
    func postHerb(_ herb: Herb) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await service.postHerb(herb)
            herbs.append(response)
        } catch {
            errorMessage = IdentifiableError(message: "Failed to post herb: \(error.localizedDescription)")
        }
    }
    
    func getHerbType(type: HerbType) -> [Herb] {
        herbs.filter { $0.type == type }
    }
}
