//
//  Service.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//



class Service: ServiceProtocol {
    private let apiClient = URLSessionAPIClient<Endpoint>()
    
    private func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        try await apiClient.request(endpoint)
    }
    
    func getCards() async throws -> [CardModel] {
        try await request(.getCards)
    }
    
    func getRunes() async throws -> [RuneModel] {
        try await request(.getRunes)
    }
    
    func getDaemons() async throws -> [DaemonModel] {
        try await request(.getDaemons)
    }
    
    func getSangoma() async throws -> SangomaModel {
        try await request(.getSangoma)
    }
    
    func getAlphabet() async throws -> [LetterModel] {
        try await request(.getAlphabet)
    }
    
    func getAstrology() async throws -> AstrologyModel {
        try await request(.getAstrology)
    }
    
    func getHerbs() async throws -> Herbs {
        try await request(.getHerbs)
    }
    
    func getHoodoo() async throws -> HoodooModel {
        try await request(.getHooboo)
    }
    
    func postHerb(_ herb: Herb) async throws -> Herb {
        try await apiClient.post(.postHerb, body: herb)
    }
}
