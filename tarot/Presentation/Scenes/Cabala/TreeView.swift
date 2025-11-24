//
//  TreeView.swift
//  tarot
//
//  Created by Fernando Marins on 24/11/24.
//

import SwiftUI

struct TreeView: View {
    @StateObject private var viewModel = TreeViewModel()
    
    var body: some View {
        ZStack {
            // Cosmic background
            LinearGradient(
                colors: [Color(hex: "0F0F20"), Color(hex: "1A0033"), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Stars overlay
            GeometryReader { geometry in
                ForEach(0..<50, id: \.self) { _ in
                    Circle()
                        .fill(Color.white.opacity(Double.random(in: 0.3...0.8)))
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
            .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            } else if let treeData = viewModel.treeData {
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            Text(treeData.leiDaCriacao.titulo)
                                .font(.system(size: 28, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 0)
                            
                            Text(treeData.leiDaCriacao.fundamento)
                                .font(.body)
                                .italic()
                                .foregroundColor(Color.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        
                        // Sephiroth List
                        ForEach(treeData.leiDaCriacao.fluxoDeManifestacao, id: \.sephirah) { sephirah in
                            SephirahCell(sephirah: sephirah)
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.fetchTreeData()
        }
        .backButtonStyle()
    }
}

struct SephirahCell: View {
    let sephirah: FluxoDeManifestacao
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                // Sephirah Number/Icon Placeholder
                ZStack {
                    Circle()
                        .fill(sephirahColor(sephirah.sephirah))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        )
                        .shadow(color: sephirahColor(sephirah.sephirah).opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Text(extractNumber(from: sephirah.sephirah))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(extractName(from: sephirah.sephirah))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(sephirah.nome)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                Divider()
                    .background(Color.white.opacity(0.2))
                
                // Details
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(title: "Planeta", value: sephirah.planeta)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Função na Criação:")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        Text(sephirah.funcaoNaCriacao)
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    
                    if let elemento = sephirah.elementoCombinado {
                        DetailRow(title: "Elemento Combinado", value: elemento)
                    }
                    
                    if let nota = sephirah.notaAdicional {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Nota Adicional:")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Text(nota)
                                .font(.caption)
                                .italic()
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    if let composicao = sephirah.composicaoElemental {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Composição Elemental:")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            Text(composicao)
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                    
                    if let elementosMalkuth = sephirah.elementosDeMalkuth {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Elementos de Malkuth:")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            ForEach(elementosMalkuth, id: \.self) { elem in
                                Text("• \(elem)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1C1C1E").opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(sephirahColor(sephirah.sephirah).opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
    
    private func extractNumber(from text: String) -> String {
        if let range = text.range(of: "#") {
            let numberString = text[range.upperBound...]
            return String(numberString).replacingOccurrences(of: ")", with: "")
        }
        return ""
    }
    
    private func extractName(from text: String) -> String {
        return text.components(separatedBy: " (").first ?? text
    }
    
    private func sephirahColor(_ name: String) -> Color {
        if name.contains("KETHER") { return .white }
        if name.contains("CHOKMAH") { return .gray }
        if name.contains("BINAH") { return .black }
        if name.contains("CHESED") { return .blue }
        if name.contains("GEBURAH") { return .red }
        if name.contains("TIPHARETH") { return .yellow }
        if name.contains("NETZACH") { return .green }
        if name.contains("HOD") { return .orange }
        if name.contains("YESOD") { return .purple }
        if name.contains("MALKUTH") { return Color(hex: "8B4513") } // Earthy brown
        return .gray
    }
}
