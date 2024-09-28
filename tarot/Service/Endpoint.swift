//
//  Service.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import Foundation

protocol APIEndpoint {
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case encodingFailed
}

enum Endpoint: APIEndpoint {
    case getCards
    case getRunes
    case getDaemons
    case getSangoma
    case getAlphabet
    case getAstrology
    case getHerbs
    case postHerb
    
    var baseURL: URL? {
        return URL(string: "https://excessive-lulu-personal-fmarins-e9736a5f.koyeb.app")
    }
    
    var path: String {
        switch self {
        case .getCards:
            return "/"
        case .getRunes:
            return "/runes"
        case .getDaemons:
            return "/daemons"
        case .getSangoma:
            return "/sangoma"
        case .getAlphabet:
            return "/alphabet"
        case .getAstrology:
            return "/astrology"
        case .getHerbs, .postHerb:
            return "/herbs"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCards,.getRunes, .getDaemons, .getSangoma, .getAlphabet, .getAstrology, .getHerbs:
            return .get
        case .postHerb:
            return .post
        }
    }
}
