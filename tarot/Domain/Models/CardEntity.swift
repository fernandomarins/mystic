//
//  CardEntity.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation
import SwiftData

@Model
class CardEntity {
    @Attribute(.unique) var id: Int
    var major: Bool
    var suit: String?
    var name: String
    var desc: String // 'description' is a reserved word in some contexts, using 'desc' to be safe
    var work: String
    var financial: String
    var love: String
    var obstacle: String
    var advice: String
    var freePerson: String?
    var takenPerson: String?
    
    init(card: CardModel) {
        self.id = card.id
        self.major = card.major
        self.suit = card.suit?.rawValue
        self.name = card.name
        self.desc = card.description
        self.work = card.work
        self.financial = card.financial
        self.love = card.love
        self.obstacle = card.obstacle
        self.advice = card.advice
        self.freePerson = card.freePerson
        self.takenPerson = card.takenPerson
    }
    
    func toModel() -> CardModel {
        CardModel(
            id: id,
            major: major,
            suit: suit.flatMap { CardSuit(rawValue: $0) },
            name: name,
            description: desc,
            work: work,
            financial: financial,
            love: love,
            obstacle: obstacle,
            advice: advice,
            freePerson: freePerson,
            takenPerson: takenPerson
        )
    }
}
