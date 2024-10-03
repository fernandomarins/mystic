//
//  Service.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Combine

protocol ServiceProtocol {
    func getCards() async -> AnyPublisher<[CardModel], Error>
    func getRunes() async -> AnyPublisher<[RuneModel], Error>
    func getDaemons() async -> AnyPublisher<[DaemonModel], Error>
    func getSangoma() async -> AnyPublisher<SangomaModel, Error>
    func getAlphabet() async -> AnyPublisher<[LetterModel], Error>
    func getAstrology() async -> AnyPublisher<AstrologyModel, Error>
    func getHerbs() async -> AnyPublisher<Herbs, Error>
    func getHoodoo() async -> AnyPublisher<HoodooModel, Error>
    func postHerb(_ herb: Herb) -> AnyPublisher<Herb, Error>
}

class Service: ServiceProtocol {
    private let apiClient = URLSessionAPIClient<Endpoint>()
    
    private func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error> {
        apiClient.request(endpoint)
    }
    
    func getCards() async -> AnyPublisher<[CardModel], Error> {
        request(.getCards)
    }
    
    func getRunes() async -> AnyPublisher<[RuneModel], Error> {
        request(.getRunes)
    }
    
    func getDaemons() async -> AnyPublisher<[DaemonModel], Error> {
        request(.getDaemons)
    }
    
    func getSangoma() async -> AnyPublisher<SangomaModel, Error> {
        request(.getSangoma)
    }
    
    func getAlphabet() async -> AnyPublisher<[LetterModel], Error> {
        request(.getAlphabet)
    }
    
    func getAstrology() async -> AnyPublisher<AstrologyModel, Error> {
        request(.getAstrology)
    }
    
    func getHerbs() async -> AnyPublisher<Herbs, Error> {
        request(.getHerbs)
    }
    
    func getHoodoo() async -> AnyPublisher<HoodooModel, Error> {
        request(.getHooboo)
    }
    
    func postHerb(_ herb: Herb) -> AnyPublisher<Herb, Error> {
        apiClient.post(.postHerb, body: herb)
    }
}
