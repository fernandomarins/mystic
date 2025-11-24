//
//  AstrologyViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation
import SwiftData

@MainActor
class AstrologyViewModel: ObservableObject {
    @Published var planets: [PlanetEntity] = []
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    private let service: AstrologyService
    
    init(service: AstrologyService = AstrologyService()) {
        self.service = service
    }
    
    func fetchAstrology(context: ModelContext) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // 1. Try to fetch from SwiftData
            let descriptor = FetchDescriptor<PlanetEntity>(sortBy: [SortDescriptor(\.name)])
            let cachedPlanets = try context.fetch(descriptor)
            
            if !cachedPlanets.isEmpty {
                self.planets = cachedPlanets
                return
            }
            
            // 2. Fetch from API
            let model = try await service.getAstrology()
            
            // 3. Map to Entities
            let newPlanets = [
                PlanetEntity(name: "Sol", signDescriptions: model.planets.sunSigns),
                PlanetEntity(name: "Lua", signDescriptions: model.planets.moonSigns),
                PlanetEntity(name: "Mercúrio", signDescriptions: model.planets.mercurySigns),
                PlanetEntity(name: "Vênus", signDescriptions: model.planets.venusSigns),
                PlanetEntity(name: "Marte", signDescriptions: model.planets.marsSigns),
                PlanetEntity(name: "Júpiter", signDescriptions: model.planets.jupiterSigns),
                PlanetEntity(name: "Saturno", signDescriptions: model.planets.saturnSigns),
                PlanetEntity(name: "Urano", signDescriptions: model.planets.uranusSigns),
                PlanetEntity(name: "Netuno", signDescriptions: model.planets.neptuneSigns),
                PlanetEntity(name: "Plutão", signDescriptions: model.planets.plutoSigns)
            ]
            
            // 4. Save to SwiftData
            for planet in newPlanets {
                context.insert(planet)
            }
            
            self.planets = newPlanets
            
        } catch {
            errorMessage = IdentifiableError(message: "Failed to fetch astrology: \(error.localizedDescription)")
        }
    }
}
