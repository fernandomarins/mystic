//
//  PontoRiscadoModel.swift
//  tarot
//
//  Created by Fernando Marins on 26/12/24.
//

import Foundation

struct PontosResponse: Codable {
    let pontos_espirituais: [PontoRiscado]
}

struct PontoRiscado: Codable, Identifiable {
    let id: Int
    let nome: String
    let definicao: String
    let instrucoes: [String]?
    let ideias_de_uso: [String]?
    let como_ativar: String?
    let reforco: String?
    let como_desativar: String?
    let comentario: String?
    let fonte: String?
    
    var imageName: String {
        "ponto_riscado_\(id)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, nome, definicao, instrucoes, ideias_de_uso, como_ativar, reforco, como_desativar, comentario, fonte
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        nome = try container.decode(String.self, forKey: .nome)
        definicao = try container.decode(String.self, forKey: .definicao)
        
        // Handle flexible "instrucoes"
        if let array = try? container.decode([String].self, forKey: .instrucoes) {
            instrucoes = array
        } else if let single = try? container.decode(String.self, forKey: .instrucoes) {
            instrucoes = [single]
        } else {
            instrucoes = nil
        }
        
        // Handle flexible "ideias_de_uso"
        if let array = try? container.decode([String].self, forKey: .ideias_de_uso) {
            ideias_de_uso = array
        } else if let single = try? container.decode(String.self, forKey: .ideias_de_uso) {
            ideias_de_uso = [single]
        } else {
            ideias_de_uso = nil
        }
        
        como_ativar = try container.decodeIfPresent(String.self, forKey: .como_ativar)
        reforco = try container.decodeIfPresent(String.self, forKey: .reforco)
        como_desativar = try container.decodeIfPresent(String.self, forKey: .como_desativar)
        comentario = try container.decodeIfPresent(String.self, forKey: .comentario)
        fonte = try container.decodeIfPresent(String.self, forKey: .fonte)
    }
}
