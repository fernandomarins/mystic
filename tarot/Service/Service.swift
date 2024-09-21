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
}

class Service: ServiceProtocol {
    let apiClient = URLSessionAPIClient<Endpoint>()
    
    func getCards() async -> AnyPublisher<[CardModel], Error> {
        apiClient.request(.getCards)
    }
    
    func getRunes() async -> AnyPublisher<[RuneModel], Error> {
        apiClient.request(.getRunes)
    }
    
    func getDaemons() async -> AnyPublisher<[DaemonModel], Error> {
        apiClient.request(.getDaemons)
    }
    
    func getSangoma() async -> AnyPublisher<SangomaModel, Error> {
        apiClient.request(.getSangoma)
    }
    
    func getAlphabet() async -> AnyPublisher<[LetterModel], Error> {
        apiClient.request(.getAlphabet)
    }
    
    func getAstrology() async -> AnyPublisher<AstrologyModel, Error> {
        apiClient.request(.getAstrology)
    }
}
