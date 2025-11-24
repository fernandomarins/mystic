//
//  RunesRepository.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation
import SwiftData

class RunesRepository {
    private let service: RuneService
    
    init(service: RuneService = RuneService()) {
        self.service = service
    }
    
    @MainActor
    func fetchRunes(context: ModelContext) async throws -> [RuneModel] {
        let descriptor = FetchDescriptor<RuneEntity>(sortBy: [SortDescriptor(\.id)])
        let localRunes = try context.fetch(descriptor)
        
        if !localRunes.isEmpty {
            return localRunes.map { $0.toModel() }
        }
        
        let remoteRunes = try await service.getRunes()
        
        for rune in remoteRunes {
            let entity = RuneEntity(rune: rune)
            context.insert(entity)
        }
        
        return remoteRunes
    }
}
