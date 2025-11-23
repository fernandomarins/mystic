//
//  APIClientProtocol.swift
//  tarot
//
//  Created by Fernando Marins on 23/11/24.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func post<T: Encodable, U: Decodable>(_ endpoint: Endpoint, body: T) async throws -> U
}
