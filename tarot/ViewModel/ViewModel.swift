//
//  ViewModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Combine
import Foundation

class ViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let service: ServiceProtocol
    @Published var cards: [CardModel] = []
    @Published var runes: [RuneModel] = []
    @Published var daemons: [DaemonModel] = []
    @Published var sangoma: SangomaModel = SangomaModel(bones: [], buzios: [])
    @Published var alphabet: [LetterModel] = []
    @Published var astrology: AstrologyModel? = nil
    @Published var herbs: [Herb] = []
    @Published var hoodoo: HoodooModel? = nil
    @Published var errorMessage: IdentifiableError? = nil
    @Published var isLoading = false
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    private func fetchData<T: Decodable>(
        fetchFunction: @escaping () async -> AnyPublisher<T, Error>,
        onSuccess: @escaping (T) -> Void
    ) async {
        await MainActor.run { isLoading = true }
        await fetchFunction()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
                if case .failure(let error) = completion {
                    self?.errorMessage = IdentifiableError(message: "Failed to fetch data: \(error.localizedDescription)")
                }
            }, receiveValue: { value in
                onSuccess(value)
            })
            .store(in: &cancellables)
    }
    
    func fetchCards() async {
        await fetchData(fetchFunction: service.getCards, onSuccess: { [weak self] response in
            self?.cards = response
        })
    }
    
    func fetchRunes() async {
        await fetchData(fetchFunction: service.getRunes, onSuccess: { [weak self] response in
            self?.runes = response
        })
    }
    
    func fetchDaemons() async {
        await fetchData(fetchFunction: service.getDaemons, onSuccess: { [weak self] response in
            self?.daemons = response
        })
    }
    
    func fetchSangoma() async {
        await fetchData(fetchFunction: service.getSangoma, onSuccess: { [weak self] response in
            self?.sangoma = response
        })
    }
    
    func fetchAlphabet() async {
        await fetchData(fetchFunction: service.getAlphabet, onSuccess: { [weak self] response in
            self?.alphabet = response
        })
    }
    
    func fetchAstrology() async {
        await fetchData(fetchFunction: service.getAstrology, onSuccess: { [weak self] response in
            self?.astrology = response
        })
    }
    
    func fetchHerbs() async {
        await fetchData(fetchFunction: service.getHerbs, onSuccess: { [weak self] response in
            self?.herbs = response.herbs
        })
    }
    
    func fetchHoodoo() async {
        await fetchData(fetchFunction: service.getHoodoo, onSuccess: { [weak self] response in
            self?.hoodoo = response
        })
    }
    
    func postHerb(_ herb: Herb) async {
        await MainActor.run { isLoading = true }
        service.postHerb(herb)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
                if case .failure(let error) = completion {
                    self?.errorMessage = IdentifiableError(message: "Failed to post herb: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                self?.herbs.append(response)
            })
            .store(in: &cancellables)
    }
}

extension ViewModel {
    func getHerbType(type: HerbType) -> [Herb] {
        herbs.filter { $0.type == type }
    }
}
