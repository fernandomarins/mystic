//
//  TreeModel.swift
//  tarot
//
//  Created by Fernando Marins on 24/11/25.
//

import Foundation

// MARK: - Welcome
struct TreeModel: Codable {
    let leiDaCriacao: LeiDaCriacao
    
    enum CodingKeys: String, CodingKey {
        case leiDaCriacao = "lei_da_criacao"
    }
}

// MARK: - LeiDaCriacao
struct LeiDaCriacao: Codable {
    let titulo, fundamento: String
    let fluxoDeManifestacao: [FluxoDeManifestacao]
    
    enum CodingKeys: String, CodingKey {
        case titulo, fundamento
        case fluxoDeManifestacao = "fluxo_de_manifestacao"
    }
}

// MARK: - FluxoDeManifestacao
struct FluxoDeManifestacao: Codable {
    let sephirah, nome, planeta, funcaoNaCriacao: String
    let elementoCombinado, notaAdicional, composicaoElemental: String?
    let elementosDeMalkuth: [String]?
    
    enum CodingKeys: String, CodingKey {
        case sephirah, nome, planeta
        case funcaoNaCriacao = "funcao_na_criacao"
        case elementoCombinado = "elemento_combinado"
        case notaAdicional = "nota_adicional"
        case composicaoElemental = "composicao_elemental"
        case elementosDeMalkuth = "elementos_de_malkuth"
    }
}
