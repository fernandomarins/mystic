//
//  DadomanciaModel.swift
//  tarot
//
//  Created by Antigravity on 10/01/26.
//

import Foundation

struct DadomanciaResponse: Decodable {
    let meanings: [DadomanciaMeaning]
    
    enum CodingKeys: String, CodingKey {
        case meanings = "dadomancia"
    }
}

struct DadomanciaMeaning: Decodable, Identifiable, Hashable {
    var id: Int { number }
    let number: Int
    let positiveMeaning: String
    let negativeMeaning: String
    let answer: String
}
