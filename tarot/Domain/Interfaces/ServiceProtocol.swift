//
//  ServiceProtocol.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation

protocol ServiceProtocol {
    func getCards() async throws -> [CardModel]
    func getRunes() async throws -> [RuneModel]
    func getDaemons() async throws -> [DaemonModel]
    func getSangoma() async throws -> SangomaModel
    func getAlphabet() async throws -> [LetterModel]
    func getAstrology() async throws -> AstrologyModel
    func getHerbs() async throws -> Herbs
    func getHoodoo() async throws -> HoodooModel
    func postHerb(_ herb: Herb) async throws -> Herb
}
