//
//  ElementsModel.swift
//  tarot
//
//  Created by Fernando Marins on 24/11/25.
//

import Foundation

struct ElementsModel: Codable {
    let forcasElementares: [ForcasElementares]
    let observacaoAdicional: String

    enum CodingKeys: String, CodingKey {
        case forcasElementares = "forcas_elementares"
        case observacaoAdicional = "observacao_adicional"
    }
}

struct ForcasElementares: Codable {
    let nome, nomeAlternativo, nomeHindu, qualidadeBasica: String
    let principioOculto, sentidoCorrespondente: String
    let simbolo: Simbolo
    let usoEmMagia, naipes: String?
    
    enum CodingKeys: String, CodingKey {
        case nome
        case nomeAlternativo = "nome_alternativo"
        case nomeHindu = "nome_hindu"
        case qualidadeBasica = "qualidade_basica"
        case principioOculto = "principio_oculto"
        case sentidoCorrespondente = "sentido_correspondente"
        case simbolo
        case usoEmMagia = "uso_em_magia"
        case naipes
    }
}

struct Simbolo: Codable {
    let forma, cor: String
}
