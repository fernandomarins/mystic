//
//  DaemonsRepository.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation
import SwiftData

class DaemonsRepository {
    private let service: DaemonService
    
    init(service: DaemonService = DaemonService()) {
        self.service = service
    }
    
    @MainActor
    func fetchDaemons(context: ModelContext) async throws -> [DaemonModel] {
        let descriptor = FetchDescriptor<DaemonEntity>(sortBy: [SortDescriptor(\.id)])
        let localDaemons = try context.fetch(descriptor)
        
        if !localDaemons.isEmpty {
            return localDaemons.map { $0.toModel() }
        }
        
        let remoteDaemons = try await service.getDaemons()
        
        for daemon in remoteDaemons {
            let entity = DaemonEntity(daemon: daemon)
            context.insert(entity)
        }
        
        return remoteDaemons
    }
}
