//
//  LetterModel.swift
//  tarot
//
//  Created by Fernando Marins on 22/09/24.
//

import Foundation

struct LetterModel: Decodable, Hashable {
    let letter, name: String
    let value: Int
    let pronunciation, meaning: String
}
