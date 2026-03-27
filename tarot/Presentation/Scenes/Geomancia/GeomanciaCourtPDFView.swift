//
//  GeomanciaCourtPDFView.swift
//  tarot
//
//  Created by Antigravity on 17/01/26.
//

import SwiftUI

struct GeomanciaCourtPDFView: View {
    let reading: GeomanciaReading
    let viewModel: GeomanciaReadingViewModel
    
    private let accentGold = Color(hex: "D4AF37")
    private let darkGold = Color(hex: "996515")
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                Text("O TRIBUNAL E O VEREDITO")
                    .font(.custom("Palatino-Bold", size: 32))
                    .foregroundColor(darkGold)
                
                Text("Consulta Geomântica")
                    .font(.custom("Palatino-Italic", size: 16))
                    .foregroundColor(.black.opacity(0.6))
                
                Rectangle()
                    .fill(accentGold.opacity(0.3))
                    .frame(width: 200, height: 1)
                    .padding(.top, 5)
            }
            .padding(.top, 40)
            .padding(.bottom, 30)
            
            // The Court (Witnesses and Judge)
            VStack(spacing: 40) {
                HStack(spacing: 60) {
                    // Left Witness (T14)
                    PDFCourtFigure(
                        label: "Testemunha Esquerda (14)",
                        subtitle: "O Quesito & Futuro",
                        pattern: reading.leftWitness,
                        name: viewModel.meaning(for: reading.leftWitness)?.name ?? ""
                    )
                    
                    // Right Witness (T13)
                    PDFCourtFigure(
                        label: "Testemunha Direita (13)",
                        subtitle: "O Consulente & Passado",
                        pattern: reading.rightWitness,
                        name: viewModel.meaning(for: reading.rightWitness)?.name ?? ""
                    )
                }
                
                // The Judge (15)
                PDFCourtFigure(
                    label: "O Juiz (15)",
                    subtitle: "O Veredito & Presente",
                    pattern: reading.judge,
                    name: viewModel.meaning(for: reading.judge)?.name ?? "",
                    isJudge: true
                )
            }
            .padding(.bottom, 50)
            
            // Interpretations Section
            VStack(alignment: .leading, spacing: 25) {
                HStack {
                    Text("ANÁLISE DO TRIBUNAL")
                        .font(.system(size: 14, weight: .black))
                        .foregroundColor(darkGold)
                        .tracking(3)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(accentGold.opacity(0.3))
                        .frame(height: 1)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    PDFInterpretationRow(
                        title: "1. Os Personagens Principais",
                        text: "**Direita (Consulente):** Representa você, sua atitude e o Passado. Se for ruim, motivação pode estar equivocada.\n**Esquerda (A Coisa):** O objetivo ou problema. Aponta para o Futuro e o potencial de benefício ou dano.\n**O Juiz (Relação):** A síntese final. O encontro entre os dois no Presente."
                    )
                    
                    PDFInterpretationRow(
                        title: "2. Matemática do Destino",
                        text: "O Juiz é gerado matematicamente pelas Testemunhas. Se sabemos quem você é e qual o problema, a relação já está traçada. Existem 128 combinações possíveis no Tribunal geomântico."
                    )
                    
                    PDFInterpretationRow(
                        title: "3. Guia de Síntese",
                        text: "Una os três em um conto: figuras favoráveis indicam sucesso total. O Juiz revela se sua força (Direita) é suficiente para vencer ou se o encontro (Esquerda) será improdutivo."
                    )
                }
                .padding(.horizontal, 10)
            }
            .padding(.horizontal, 50)
            
            Spacer()
            
            // Footer
            VStack(spacing: 8) {
                Text("“Como é em cima, assim é embaixo.”")
                    .font(.custom("Palatino-Italic", size: 12))
                    .foregroundColor(darkGold.opacity(0.6))
                
                Text(Date().formatted(date: .long, time: .shortened))
                    .font(.system(size: 10))
                    .foregroundColor(.black.opacity(0.3))
            }
            .padding(.bottom, 40)
        }
        .frame(width: 595, height: 842) // A4 Size at 72dpi
        .background(Color.white)
    }
}

private struct PDFCourtFigure: View {
    let label: String
    let subtitle: String
    let pattern: [Int]
    let name: String
    var isJudge: Bool = false
    
    private let accentGold = Color(hex: "D4AF37")
    
    var body: some View {
        VStack(spacing: 12) {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.black.opacity(0.4))
                .tracking(1)
            
            VStack(spacing: 8) {
                GeomanticSymbolView(pattern: pattern, color: .black, dotSize: 10, spacing: 10)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(accentGold.opacity(0.3), lineWidth: 1)
                    .background(accentGold.opacity(0.02))
            )
            
            VStack(spacing: 2) {
                Text(name.uppercased())
                    .font(.custom("Palatino-Bold", size: 20))
                    .foregroundColor(isJudge ? Color(hex: "996515") : .black)
                
                Text(subtitle)
                    .font(.custom("Palatino-Italic", size: 10))
                    .foregroundColor(.black.opacity(0.5))
            }
        }
        .frame(width: 200)
    }
}

private struct PDFInterpretationRow: View {
    let title: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)
            
            Text(text)
                .font(.custom("Palatino", size: 14))
                .foregroundColor(.black.opacity(0.7))
                .lineSpacing(4)
        }
    }
}
