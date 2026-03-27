//
//  GeomanciaCourtView.swift
//  tarot
//
//  Created by Antigravity on 17/01/26.
//

import SwiftUI

struct GeomanciaCourtView: View {
    @ObservedObject var viewModel: GeomanciaReadingViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedMeaning: GeomanciaMeaning?
    @State private var isShowingPDFPreview = false
    
    private let accentGold = Color(hex: "D4AF37")
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "1F140F"), Color(hex: "0F0C08")],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 35) {
                    // Header
                    VStack(spacing: 15) {
                        Capsule()
                            .fill(.white.opacity(0.2))
                            .frame(width: 36, height: 5)
                            .padding(.top, 12)
                        
                        Text("O Tribunal e o Veredito")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)
                        
                        Text("A fundação mística da leitura geomântica")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(accentGold.opacity(0.7))
                            .tracking(1)
                    }
                    
                    // The Triangular Layout (WITNESSES & JUDGE)
                    VStack(spacing: 25) {
                        HStack(spacing: 30) {
                            // Left Witness (T14) - Quesited/Future
                            CourtVerticalCell(
                                label: "TESTEMUNHA ESQUERDA (14)",
                                subtitle: "O Quesito & Futuro",
                                pattern: viewModel.reading.leftWitness,
                                viewModel: viewModel,
                                side: .left,
                                onTap: { meaning in selectedMeaning = meaning }
                            )
                            
                            // Right Witness (T13) - Querent/Past
                            CourtVerticalCell(
                                label: "TESTEMUNHA DIREITA (13)",
                                subtitle: "O Consulente & Passado",
                                pattern: viewModel.reading.rightWitness,
                                viewModel: viewModel,
                                side: .right,
                                onTap: { meaning in selectedMeaning = meaning }
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        // Decorative connection
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Spacer()
                                Rectangle().fill(accentGold.opacity(0.2)).frame(width: 1, height: 20)
                                Spacer()
                                Rectangle().fill(accentGold.opacity(0.2)).frame(width: 1, height: 20)
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Rectangle().fill(accentGold.opacity(0.2)).frame(height: 1)
                                Spacer()
                            }
                            .frame(width: 150)
                            Rectangle().fill(accentGold.opacity(0.2)).frame(width: 1, height: 20)
                        }
                        
                        // The Judge (15) - Relationship/Present
                        CourtVerticalCell(
                            label: "O JUIZ (15)",
                            subtitle: "O Relacionamento & Presente",
                            pattern: viewModel.reading.judge,
                            viewModel: viewModel,
                            isHighlight: true,
                            side: .center,
                            onTap: { meaning in selectedMeaning = meaning }
                        )
                        .frame(width: 200)
                    }
                    .padding(.top, 10)
                    
                    // Interpretations Section
                    VStack(alignment: .leading, spacing: 25) {
                        HStack(spacing: 12) {
                            Rectangle().fill(accentGold.opacity(0.1)).frame(height: 1)
                            Text("GUIA DE INTERPRETAÇÃO")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(accentGold)
                                .tracking(3)
                                .fixedSize(horizontal: true, vertical: false)
                            Rectangle().fill(accentGold.opacity(0.1)).frame(height: 1)
                        }
                        .padding(.bottom, 5)
                        
                        InterpretationBox(
                            title: "1. Os Personagens principais",
                            icon: "person.2.fill",
                            text: "**Testemunha da Direita (O Consulente / VOCÊ):** Ela representa você no momento da pergunta. Mostra sua atitude, sua força na situação e o seu passado. Se a figura aqui for ruim, sugere que você está começando de uma posição fraca ou com uma motivação equivocada.\n\n**Testemunha da Esquerda (O Quesito / A COISA):** Representa o objetivo, a pessoa ou o problema sobre o qual você está perguntando. Ela aponta para o futuro e para o potencial que essa coisa tem de te beneficiar ou te prejudicar.\n\n**O Juiz (O Veredito / A RELAÇÃO):** É a síntese. Ele não representa nem você, nem a coisa, mas sim o encontro entre os dois. É o presente e a resposta final (Sim ou Não)."
                        )
                        
                        InterpretationBox(
                            title: "2. A Matemática do Destino",
                            icon: "function",
                            text: "Diferente do Tarot, onde qualquer carta pode sair ao lado de qualquer outra, na Geomancia o Juiz é *gerado* pelas Testemunhas. Se você tem a Testemunha X e a Testemunha Y, o Juiz obrigatoriamente será Z. Isso significa que, se você sabe quem é o Consulente e qual é o Problema, a relação entre eles já está matematicamente traçada. Por isso existem apenas 128 combinações possíveis no Tribunal."
                        )
                        
                        InterpretationBox(
                            title: "3. Como interpretar a História",
                            icon: "book.fill",
                            text: "**Exemplo 1 (Tudo Positivo):** Testemunhas favoráveis + Juiz favorável = Sucesso total. Você está bem, o objetivo é bom e o resultado será excelente.\n\n**Exemplo 2 (Conflito):** Você (Direita) é forte, mas o Objetivo (Esquerda) é uma figura de perda. O Juiz será o resultado dessa luta. Mesmo que você seja forte, se o Juiz for negativo, o encontro não será produtivo.\n\n**Exemplo 3 (Conselho de Atitude):** O exemplo de Puer na Direita indica que você está indo para a situação com 'mais entusiasmo do que bom senso'. A figura não diz apenas se é bom ou ruim, mas como você está se comportando."
                        )
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("O Tribunal te dá uma leitura rápida: a Direita mostra o que você traz (Atitude/Passado), a Esquerda o que a situação reserva (Potencial/Futuro) e o Juiz o resultado do encontro (Presente).")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(accentGold.opacity(0.9))
                                .lineSpacing(4)
                                .italic()
                        }
                        .padding(25)
                        .background(RoundedRectangle(cornerRadius: 24).fill(accentGold.opacity(0.08)))
                    }
                    .padding(.horizontal, 25)
                    
                    Button(action: { dismiss() }) {
                        Text("Voltar para Detalhes")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(maxWidth: .infinity)
                            .height(56)
                            .background(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.2), lineWidth: 1))
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    
                    if #available(iOS 16.0, *) {
                        Button(action: { isShowingPDFPreview = true }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Exportar Tribunal (PDF)")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .height(56)
                            .background(RoundedRectangle(cornerRadius: 16).fill(accentGold))
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                        .sheet(isPresented: $isShowingPDFPreview) {
                            NavigationView {
                                VStack {
                                    GeomanciaCourtPDFView(reading: viewModel.reading, viewModel: viewModel)
                                        .scaleEffect(0.5)
                                        .frame(width: 300, height: 420)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(radius: 5)
                                        .padding()
                                    
                                    Spacer()
                                    
                                    ShareLink(item: renderCourtPDF(), preview: SharePreview("O Tribunal Geomântico", image: Image(systemName: "scalemass.fill"))) {
                                        Label("Compartilhar PDF", systemImage: "square.and.arrow.up")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .height(50)
                                            .background(Capsule().fill(accentGold))
                                            .padding(.horizontal, 40)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .navigationTitle("Pré-visualização")
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarLeading) {
                                        Button("Cancelar") { isShowingPDFPreview = false }
                                    }
                                }
                                .background(Color.gray.opacity(0.1))
                            }
                        }
                    } else {
                        Spacer().frame(height: 40)
                    }
                }
            }
        }
        .sheet(item: $selectedMeaning) { meaning in
            GeomanciaDetailView(item: meaning)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
    
    // PDF Rendering Helper
    @MainActor
    @available(iOS 16.0, *)
    private func renderCourtPDF() -> URL {
        let renderer = ImageRenderer(content: GeomanciaCourtPDFView(reading: viewModel.reading, viewModel: viewModel))
        
        // Use A4 size in points (595 x 842)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("tribunal_geomancia.pdf")
        
        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            
            pdf.beginPDFPage(nil)
            context(pdf)
            pdf.endPDFPage()
            pdf.closePDF()
        }
        
        return url
    }
}

private struct CourtVerticalCell: View {
    let label: String
    let subtitle: String
    let pattern: [Int]
    let viewModel: GeomanciaReadingViewModel
    var isHighlight: Bool = false
    enum Side { case left, right, center }
    let side: Side
    var onTap: ((GeomanciaMeaning) -> Void)?
    
    private let accentGold = Color(hex: "D4AF37")
    
    var body: some View {
        Button(action: {
            if let meaning = viewModel.meaning(for: pattern) {
                onTap?(meaning)
            }
        }) {
            VStack(spacing: 12) {
                Text(label)
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(isHighlight ? accentGold : .white.opacity(0.4))
                    .tracking(1)
                
                VStack(spacing: 8) {
                    GeomanticSymbolView(pattern: pattern, color: isHighlight ? accentGold : .white, dotSize: 7, spacing: 7)
                }
                .padding(15)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(isHighlight ? accentGold.opacity(0.1) : Color.white.opacity(0.05))
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(isHighlight ? accentGold.opacity(0.3) : .clear, lineWidth: 1))
                )
                
                if let meaning = viewModel.meaning(for: pattern) {
                    VStack(spacing: 4) {
                        Text(meaning.name.uppercased())
                            .font(.system(size: 15, weight: .black, design: .serif))
                            .foregroundColor(.white)
                            .tracking(1)
                        
                        Text(subtitle)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(accentGold.opacity(0.6))
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private struct InterpretationBox: View {
    let title: String
    let icon: String
    let text: String
    
    private let accentGold = Color(hex: "D4AF37")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(accentGold)
                    .font(.system(size: 14))
                
                Text(title)
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(.white)
                    .tracking(1)
            }
            
            Text(LocalizedStringKey(text))
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.85))
                .lineSpacing(5)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.04))
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.1), lineWidth: 1))
        )
    }
}
