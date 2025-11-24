//
//  HoodooView.swift
//  tarot
//
//  Created by Fernando Marins on 03/10/24.
//

import SwiftUI

struct HoodooView: View {
    let item: HoodooItem
    var body: some View {
        Text(item.name.uppercased())
            .bold()
            .font(.title2)
        List {
            Section(header: Text("Materiais")) {
                ForEach(item.materials, id: \.self) { material in
                    Text(material.name)
                }
            }
            
            if let procedure = item.procedure {
                Section(header: Text("Procedimento")) {
                    Text(procedure)
                }
            }
            
            if let use = item.use {
                Section(header: Text("Uso")) {
                    Text(use)
                }
            }
        }
        .backButtonStyle()
    }
}

#Preview {
    HoodooView(item: .init(name: "Banimento da vela preta", type: .spell, materials: [.init(name: "Vela"), .init(name: "Alfinete"), .init(name: "Óleo de banimento")], procedure: "Este é um feitiço muito versátil que pode ser usado para banir pessoas, coisas que você precisar. Você vai escrever o nome (inimigo) em uma vela preta, vista com óleo de banimento. Alguns conjures escolhem escrever o nome de cabeça para baixo e de trás para a frente. A escolha, no entanto, é sua. Pegue os alfinetes e introduza-os através da vela entre cada letra do nome. Se você puder obter qualquer link pessoal, envolva-os em uma petição por escrito colocada sob a vela. À medida que a vela diminuir a cada letra do nome, faça sua oração para que ele saia. Você pode dizer algo como:\n\n'Senhor, como você fez o cego ver, deixe (fulano) ver que ele não pertence mais aqui; como você fez o coxo andar, deixe-o sair de minha vida para sempre; ao curar os enfermos, cure as feridas que (fulano) infligiu sobre mim e minha família, etc.…'\n\nComo você pode ver, você pode adaptar o texto de sua oração às suas necessidades específicas.\n\nQuando a vela queimar, prenda os alfinetes na petição, despache tudo em um rio, cachoeira e vá embora sem olhar para trás.", use: nil, categoryType: ""))
}
