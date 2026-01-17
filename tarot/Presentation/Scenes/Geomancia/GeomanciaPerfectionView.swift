//
//  GeomanciaPerfectionView.swift
//  tarot
//
//  Created by Antigravity on 16/01/26.
//

import SwiftUI

struct GeomanciaPerfectionView: View {
    @ObservedObject var viewModel: GeomanciaReadingViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedHouseId: Int = 10 // Default to Career/House 10
    @State private var result: GeomanciaReadingViewModel.PerfectionResult? = nil
    
    // Common questions mapped to houses
    let commonQuestions: [(String, Int)] = [
        ("Dinheiro/Bens (Casa 2)", 2),
        ("Notícias/Irmãos (Casa 3)", 3),
        ("Família/Pai/Casa (Casa 4)", 4),
        ("Filhos/Diversão/Gravidez (Casa 5)", 5),
        ("Saúde/Empregados (Casa 6)", 6),
        ("Amor/Casamento/Parcerias (Casa 7)", 7),
        ("Heranças/Morte/Magia (Casa 8)", 8),
        ("Viagens/Estudos (Casa 9)", 9),
        ("Carreira/Fama (Casa 10)", 10),
        ("Amigos/Esperanças (Casa 11)", 11),
        ("Inimigos Secretos/Prisão (Casa 12)", 12)
    ]
    
    private let accentGold = Color(hex: "D4AF37")
    private let bgGradient = LinearGradient(
        colors: [Color(hex: "1B1212"), Color(hex: "2D1B10")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        ZStack {
            bgGradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 25) {
                        infoCard
                        selectionCard
                        
                        if let res = result {
                            resultCard(for: res)
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Perfeição Geomântica")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                Text("Resposta Sim/Não")
                    .font(.system(size: 14))
                    .foregroundColor(accentGold.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(10)
                    .background(Circle().fill(.white.opacity(0.1)))
            }
        }
        .padding(25)
    }
    
    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SOBRE ESTA TÉCNICA")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(accentGold)
                .tracking(2)
            
            Text("A Perfeição responde perguntas de 'Sim' ou 'Não' verificando a conexão entre você (Casa 1) e o assunto desejado.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.03)))
        .padding(.horizontal, 20)
    }
    
    private var selectionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Assunto da Pergunta")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Menu {
                ForEach(commonQuestions, id: \.1) { item in
                    Button(item.0) {
                        selectedHouseId = item.1
                    }
                }
            } label: {
                HStack {
                    Text(commonQuestions.first(where: { $0.1 == selectedHouseId })?.0 ?? "Selecione")
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(accentGold)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.05))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(accentGold.opacity(0.3), lineWidth: 1))
                )
            }
            
            Button(action: {
                withAnimation {
                    result = viewModel.checkPerfection(quesitedHouse: selectedHouseId)
                }
            }) {
                Text("Verificar Perfeição")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(accentGold)
                            .shadow(color: accentGold.opacity(0.3), radius: 10)
                    )
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.03)))
        .padding(.horizontal, 20)
    }
    
    private func resultCard(for res: GeomanciaReadingViewModel.PerfectionResult) -> some View {
        VStack(spacing: 20) {
            // Answer Badge
            HStack {
                Text(res.isPerfected ? "SIM" : "NÃO")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(res.isPerfected ? .green : .red)
                
                Spacer()
                
                if res.type != .none {
                    Text(res.type.rawValue.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(accentGold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(accentGold.opacity(0.2))
                                .overlay(Capsule().stroke(accentGold, lineWidth: 1))
                        )
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            Text(res.description)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
            
            if res.isPerfected {
                connectionInfo(for: res)
                
                // Conjunction Details
                if let conjDetails = res.conjunctionDetails {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Detalhes da Conjunção")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                            .tracking(1)
                        
                        Text(conjDetails)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(4)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                    .padding(.top, 8)
                }
                
                if let quality = res.qualityAssessment {
                    qualityCard(quality: quality)
                }
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.05)))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(res.isPerfected ? Color.green.opacity(0.3) : Color.red.opacity(0.3), lineWidth: 2))
        .padding(.horizontal, 20)
    }
    
    private func connectionInfo(for res: GeomanciaReadingViewModel.PerfectionResult) -> some View {
        HStack {
            Text("Conexão:")
                .font(.caption)
                .bold()
                .foregroundColor(.white.opacity(0.6))
            Text("\(res.querentFigureName) ↔ \(res.quesitedFigureName)")
                .font(.caption)
                .italic()
                .foregroundColor(accentGold)
        }
        .padding(.top, 4)
    }
    
    private func qualityCard(quality: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Qualidade do Resultado")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
                .tracking(1)
            
            Text(quality)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(quality.contains("⚠️") ? Color.orange.opacity(0.15) : Color.green.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(quality.contains("⚠️") ? Color.orange.opacity(0.3) : Color.green.opacity(0.3), lineWidth: 1)
                        )
                )
        }
        .padding(.top, 8)
    }
}
