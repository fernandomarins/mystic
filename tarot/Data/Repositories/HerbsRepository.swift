//
//  HerbsRepository.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation
import SwiftData

class HerbsRepository {
    private let service: HerbsService
    
    init(service: HerbsService = HerbsService()) {
        self.service = service
    }
    
    @MainActor
    func fetchHerbs(context: ModelContext) async throws -> [Herb] {
        let descriptor = FetchDescriptor<HerbEntity>(sortBy: [SortDescriptor(\.name)])
        let localHerbs = try context.fetch(descriptor)
        
        if !localHerbs.isEmpty {
            return localHerbs.map { $0.toModel() }
        }
        
        let remoteHerbs = try await service.getHerbs()
        
        for herb in remoteHerbs.herbs {
            let entity = HerbEntity(herb: herb)
            context.insert(entity)
        }
        
        return remoteHerbs.herbs
    }
}
