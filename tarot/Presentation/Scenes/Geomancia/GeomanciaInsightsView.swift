//
//  GeomanciaInsightsView.swift
//  tarot
//
//  Created by Antigravity on 16/01/26.
//

import SwiftUI

struct GeomanciaInsightsView: View {
    @ObservedObject var viewModel: GeomanciaReadingViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedHouse: GeomanciaReadingViewModel.HouseDefinition? = nil
    @State private var selectedMeaning: GeomanciaMeaning?
    
    private let accentGold = Color(hex: "D4AF37")
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "1F140F"), Color(hex: "0F0C08")],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            // Decorative elements
            VStack {
                Spacer()
                Image(systemName: "sparkles")
                    .foregroundColor(accentGold.opacity(0.05))
                    .font(.system(size: 300))
                    .offset(y: 100)
            }
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 15) {
                        Capsule()
                            .fill(.white.opacity(0.2))
                            .frame(width: 36, height: 5)
                            .padding(.top, 12)
                        
                        Text("Insights Avançados")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 10)
                    
                    VStack(spacing: 20) {
                        // 1. Timing/Speed
                        InsightSection(
                            title: "VELOCIDADE (TEMPO)",
                            value: "\(viewModel.totalPoints) Pontos — \(viewModel.timingVerdict)",
                            icon: "clock.fill",
                            description: "Baseado na soma total de pontos das 15 figuras do escudo. O número místico de equilíbrio é 96.",
                            explanation: "Se a soma total for menor que 96, o resultado tende a se manifestar mais rápido do que o esperado. Se for maior, indica atrasos, obstáculos ou um processo mais lento de maturação.",
                            accentColor: accentGold
                        )
                        
                        // 2. Part of Fortune
                        InsightSection(
                            title: "PARTE DA FORTUNA",
                            value: "Casa \(viewModel.partOfFortuneHouse)",
                            icon: "sparkles",
                            description: "O ponto onde a energia geomântica 'aterrisa' materialmente na sua vida.",
                            explanation: "Esta casa indica onde o sucesso e o benefício material da questão são mais prováveis de ocorrer. É o ponto de maior harmonia física entre o consulente e o universo.",
                            accentColor: .green,
                            houseId: viewModel.partOfFortuneHouse,
                            viewModel: viewModel,
                            selectedHouse: $selectedHouse
                        )
                        
                        // 3. Spirit Index
                        InsightSection(
                            title: "ÍNDICE DO ESPÍRITO",
                            value: "Casa \(viewModel.spiritIndexHouse)",
                            icon: "bolt.fill",
                            description: "A motivação oculta ou o foco espiritual por trás da sua pergunta.",
                            explanation: "Enquanto a Parte da Fortuna lida com o material, o Índice do Espírito mostra onde sua intenção e mente estão realmente focadas, às vezes revelando uma prioridade que você nem percebeu.",
                            accentColor: .blue,
                            houseId: viewModel.spiritIndexHouse,
                            viewModel: viewModel,
                            selectedHouse: $selectedHouse
                        )
                        
                        Divider().background(Color.white.opacity(0.1)).padding(.vertical, 10)
                        
                        // 4. Court Figures (Figuras de Corte)
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("A CORTE DO DESTINO")
                                    .font(.system(size: 14, weight: .black))
                                    .foregroundColor(accentGold)
                                    .tracking(2)
                                Spacer()
                                Image(systemName: "crown.fill")
                                    .foregroundColor(accentGold.opacity(0.5))
                            }
                            
                            Text("As figuras de corte dão a visão geral da situação e são a primeira coisa que você deve analisar.")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                            
                            VStack(alignment: .leading, spacing: 20) {
                                CourtFigureRow(
                                    title: "TESTEMUNHA DA DIREITA",
                                    subtitle: "Passado & Consulente",
                                    icon: "person.fill.turn.right",
                                    explanation: "Representa você, o que você traz para a questão e as influências do passado.",
                                    pattern: viewModel.reading.rightWitness,
                                    viewModel: viewModel,
                                    onTap: { meaning in selectedMeaning = meaning }
                                )
                                
                                CourtFigureRow(
                                    title: "TESTEMUNHA DA ESQUERDA",
                                    subtitle: "Futuro & A Questão",
                                    icon: "arrow.right.circle.fill",
                                    explanation: "Fala da questão em si, os eventos externos e as tendências do futuro.",
                                    pattern: viewModel.reading.leftWitness,
                                    viewModel: viewModel,
                                    onTap: { meaning in selectedMeaning = meaning }
                                )
                                
                                CourtFigureRow(
                                    title: "O JUIZ",
                                    subtitle: "Presente & Síntese",
                                    icon: "scalemass.fill",
                                    explanation: "A síntese final e o presente. Revela a relação entre você e o seu objetivo.",
                                    pattern: viewModel.reading.judge,
                                    viewModel: viewModel,
                                    isHighlight: true,
                                    onTap: { meaning in selectedMeaning = meaning }
                                )
                            }
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color.white.opacity(0.03))
                                .overlay(RoundedRectangle(cornerRadius: 32).stroke(accentGold.opacity(0.1), lineWidth: 1))
                        )
                        
                        Divider().background(Color.white.opacity(0.1)).padding(.vertical, 10)
                        
                        // 5. Via Puncti (Caminho dos Pontos)
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("VIA PUNCTI")
                                    .font(.system(size: 14, weight: .black))
                                    .foregroundColor(accentGold)
                                    .tracking(2)
                                Spacer()
                                Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                                    .foregroundColor(accentGold.opacity(0.5))
                            }
                            
                            Text("Esta é a técnica de rastrear a 'raiz' da questão através da cabeça do Juiz.")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                            
                            let path = viewModel.viaPunctiPath
                            if path.isEmpty {
                                Text("A Via Puncti não pôde ser formada nesta leitura. Isso significa que não há motivações ocultas profundas: o que se tem é o que se vê.")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white.opacity(0.5))
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.02)))
                            } else {
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(path.indices, id: \.self) { i in
                                        let step = path[i]
                                        HStack(spacing: 15) {
                                            VStack(spacing: 0) {
                                                Circle()
                                                    .fill(accentGold)
                                                    .frame(width: 8, height: 8)
                                                
                                                if i < path.count - 1 {
                                                    Rectangle()
                                                        .fill(accentGold.opacity(0.3))
                                                        .frame(width: 2, height: 40)
                                                }
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                HStack(spacing: 6) {
                                                    Text(step.figureTitle)
                                                        .font(.system(size: 12, weight: .bold))
                                                        .foregroundColor(.white)
                                                    
                                                    if let houseId = step.houseId {
                                                        Text("—")
                                                            .font(.system(size: 10, weight: .black))
                                                            .foregroundColor(accentGold.opacity(0.3))
                                                        
                                                        Text("CASA \(houseId)")
                                                            .font(.system(size: 10, weight: .black))
                                                            .foregroundColor(accentGold.opacity(0.6))
                                                    }
                                                }
                                                
                                                if let meaning = viewModel.meaning(for: step.pattern) {
                                                    Text(meaning.name)
                                                        .font(.system(size: 10, weight: .bold))
                                                        .foregroundColor(accentGold)
                                                }
                                                
                                                Text("Origem: \(step.parentTitle)")
                                                    .font(.system(size: 9))
                                                    .foregroundColor(.white.opacity(0.4))
                                            }
                                            .padding(.bottom, i < path.count - 1 ? 20 : 0)
                                        }
                                    }
                                }
                                .padding(20)
                                .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.02)))
                                
                                Text("As figuras acima explicam as origens profundas e causas raízes da sua pergunta.")
                                    .font(.system(size: 11))
                                    .foregroundColor(accentGold.opacity(0.6))
                                    .italic()
                            }
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color.white.opacity(0.03))
                                .overlay(RoundedRectangle(cornerRadius: 32).stroke(accentGold.opacity(0.1), lineWidth: 1))
                        )
                    }
                    .padding(.horizontal, 25)
                    
                    Button(action: { dismiss() }) {
                        Text("Voltar para a Leitura")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .height(56)
                            .background(RoundedRectangle(cornerRadius: 16).fill(accentGold))
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .blur(radius: selectedHouse != nil ? 10 : 0)
            
            // Floating Overlay for House Info
            if let house = selectedHouse {
                ZStack {
                    Color.black.opacity(0.6).ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { selectedHouse = nil }
                        }
                    
                    HouseInfoPopover(house: house) {
                        withAnimation { selectedHouse = nil }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                .zIndex(10)
            }
        }
        .sheet(item: $selectedMeaning) { meaning in
            GeomanciaDetailView(item: meaning)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct InsightSection: View {
    let title: String
    let value: String
    let icon: String
    let description: String
    let explanation: String
    let accentColor: Color
    var houseId: Int? = nil
    var viewModel: GeomanciaReadingViewModel? = nil
    @Binding var selectedHouse: GeomanciaReadingViewModel.HouseDefinition?
    
    // Initializer to handle the default binding value
    init(title: String, value: String, icon: String, description: String, explanation: String, accentColor: Color, houseId: Int? = nil, viewModel: GeomanciaReadingViewModel? = nil, selectedHouse: Binding<GeomanciaReadingViewModel.HouseDefinition?> = .constant(nil)) {
        self.title = title
        self.value = value
        self.icon = icon
        self.description = description
        self.explanation = explanation
        self.accentColor = accentColor
        self.houseId = houseId
        self.viewModel = viewModel
        self._selectedHouse = selectedHouse
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(accentColor.opacity(0.7))
                    .tracking(2)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text(value)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    if let hid = houseId, let vm = viewModel {
                        Button(action: {
                            withAnimation {
                                selectedHouse = vm.housesData.first(where: { $0.id == hid })
                            }
                        }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 14))
                                .foregroundColor(accentColor)
                        }
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(description)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white.opacity(0.9))
                
                Text(explanation)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
                    .lineSpacing(4)
            }
        }
        .padding(25)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.04))
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.1), lineWidth: 1))
        )
    }
}

struct CourtFigureRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let explanation: String
    let pattern: [Int]
    let viewModel: GeomanciaReadingViewModel
    var isHighlight: Bool = false
    var onTap: ((GeomanciaMeaning) -> Void)?
    
    private let accentGold = Color(hex: "D4AF37")
    
    var body: some View {
        Button(action: {
            if let meaning = viewModel.meaning(for: pattern) {
                onTap?(meaning)
            }
        }) {
            HStack(alignment: .top, spacing: 15) {
                VStack {
                    GeomanticSymbolView(pattern: pattern, color: isHighlight ? accentGold : .white, dotSize: 4, spacing: 4)
                        .padding(10)
                        .background(Circle().fill(isHighlight ? accentGold.opacity(0.1) : Color.white.opacity(0.05)))
                        .overlay(Circle().stroke(isHighlight ? accentGold.opacity(0.3) : .clear, lineWidth: 1))
                }
                .padding(.top, 4)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(isHighlight ? accentGold : .white.opacity(0.5))
                            .tracking(1)
                        
                        if let meaning = viewModel.meaning(for: pattern) {
                            Text("—")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(isHighlight ? accentGold : .white.opacity(0.3))
                            
                            Text(meaning.name.uppercased())
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(isHighlight ? accentGold : .white.opacity(0.8))
                        }
                    }
                    
                    Text(subtitle)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(explanation)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.6))
                        .lineSpacing(2)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HouseInfoPopover: View {
    let house: GeomanciaReadingViewModel.HouseDefinition
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(house.icon)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(house.name)
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                    
                    Text(house.quality)
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(Color(hex: "D4AF37"))
                        .tracking(1)
                }
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.2))
                }
            }
            
            Divider().background(Color.white.opacity(0.1))
            
            Text(house.description)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: onDismiss) {
                Text("Entendido")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .height(44)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(hex: "D4AF37")))
            }
            .padding(.top, 10)
        }
        .padding(25)
        .frame(width: 320)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color(hex: "2D1B10"))
                .overlay(RoundedRectangle(cornerRadius: 32).stroke(Color(hex: "D4AF37").opacity(0.3), lineWidth: 1))
                .shadow(color: .black.opacity(0.5), radius: 30)
        )
    }
}
