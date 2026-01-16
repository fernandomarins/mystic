//
//  PontoRiscadoDetailView.swift
//  tarot
//
//  Created by Fernando Marins on 27/12/24.
//

import SwiftUI

struct PontoRiscadoDetailView: View {
    let ponto: PontoRiscado
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Forest Background
            LinearGradient(
                colors: [Color(hex: "081C15"), Color(hex: "1B4332"), Color(hex: "081C15")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.1)))
                    }
                    
                    Spacer()
                    
                    Text("Detalhes")
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for balance
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.clear)
                        .padding()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Image section
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color(hex: "2D6A4F").opacity(0.2))
                                .frame(height: 300)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color(hex: "40916C").opacity(0.3), lineWidth: 1)
                                )
                            
                            if let image = UIImage(named: ponto.imageName) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(30)
                            } else {
                                VStack(spacing: 12) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 60))
                                        .foregroundColor(Color(hex: "D8F3DC").opacity(0.3))
                                    Text("Imagem em breve")
                                        .font(.caption)
                                        .foregroundColor(Color(hex: "D8F3DC").opacity(0.5))
                                }
                            }
                        }
                        
                        // Title and Fonte
                        VStack(alignment: .leading, spacing: 8) {
                            Text(ponto.nome)
                                .font(.system(size: 32, weight: .bold, design: .serif))
                                .foregroundColor(Color(hex: "D8F3DC"))
                            
                            if let fonte = ponto.fonte {
                                Text("Fonte: \(fonte)")
                                    .font(.system(.subheadline, design: .serif))
                                    .foregroundColor(.white.opacity(0.5))
                                    .italic()
                            }
                        }
                        
                        // Definition
                        VStack(alignment: .leading, spacing: 12) {
                            PontoSectionHeader(title: "Definição")
                            Text(ponto.definicao)
                                .font(.system(.body, design: .serif))
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(6)
                        }
                        
                        // Instructions
                        if let instrucoes = ponto.instrucoes, !instrucoes.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                PontoSectionHeader(title: "Instruções")
                                ForEach(instrucoes, id: \.self) { item in
                                    BulletPoint(text: parseMysticalText(item))
                                }
                            }
                        }
                        
                        // Ideas of use
                        if let ideias = ponto.ideias_de_uso, !ideias.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                PontoSectionHeader(title: "Ideias de Uso")
                                ForEach(ideias, id: \.self) { item in
                                    BulletPoint(text: parseMysticalText(item))
                                }
                            }
                        }
                        
                        // Activation
                        if let ativar = ponto.como_ativar {
                            VStack(alignment: .leading, spacing: 12) {
                                PontoSectionHeader(title: "Como Ativar")
                                parseMysticalText(ativar)
                                    .font(.system(.body, design: .serif))
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineSpacing(6)
                            }
                        }
                        
                        // Reinforcement
                        if let reforco = ponto.reforco {
                            VStack(alignment: .leading, spacing: 12) {
                                PontoSectionHeader(title: "Reforço")
                                parseMysticalText(reforco)
                                    .font(.system(.body, design: .serif))
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineSpacing(6)
                            }
                        }
                        
                        // Deactivation
                        if let desativar = ponto.como_desativar {
                            VStack(alignment: .leading, spacing: 12) {
                                PontoSectionHeader(title: "Como Desativar")
                                parseMysticalText(desativar)
                                    .font(.system(.body, design: .serif))
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineSpacing(6)
                            }
                        }
                        
                        // Comment
                        if let comentario = ponto.comentario {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Observação:")
                                    .font(.system(.headline, design: .serif))
                                    .foregroundColor(Color(hex: "95D5B2"))
                                parseMysticalText(comentario)
                                    .font(.system(.subheadline, design: .serif))
                                    .foregroundColor(.white.opacity(0.7))
                                    .italic()
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                    .padding(24)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func parseMysticalText(_ text: String) -> Text {
        if text.isEmpty { return Text("") }
        // Simple parser for {italic} tags in JSON
        var parsed = text.replacingOccurrences(of: "{italic}", with: "*")
        parsed = parsed.replacingOccurrences(of: "{/italic}", with: "*")
        return Text(LocalizedStringKey(parsed))
    }
}

struct PontoSectionHeader: View {
    let title: String
    var body: some View {
        HStack(spacing: 12) {
            Text(title.uppercased())
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(hex: "95D5B2"))
                .tracking(2)
            
            Rectangle()
                .fill(Color(hex: "40916C").opacity(0.3))
                .frame(height: 1)
        }
    }
}

struct BulletPoint: View {
    let text: Text
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("✦")
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "D8F3DC"))
                .padding(.top, 4)
            text
                .font(.system(.body, design: .serif))
                .foregroundColor(.white.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
