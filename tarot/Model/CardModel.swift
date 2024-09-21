//
//  CardModel.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation

struct CardModel: Decodable, Identifiable, Hashable {
    let id: Int
    let major: Bool
    let suit: CardSuit?
    let name, description, work, financial, love, obstacle, advice: String
    let freePerson, takenPerson: String?
    
    enum CodingKeys: String, CodingKey {
        case id, major, suit, name, description, work, financial, love
        case freePerson = "free_person"
        case takenPerson = "taken_person"
        case obstacle, advice
    }
}

enum CardSuit: String, Decodable {
    case diamonds
    case hearts
    case spades
    case clubs
}
