//
//  GeomanciaReadingView.swift
//  tarot
//
//  Created by Antigravity on 15/01/26.
//

import SwiftUI

struct GeomanciaReadingView: View {
    @StateObject private var viewModel = GeomanciaReadingViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var isShowingHouses = false
    
    // Theme Colors
    private let bgGradient = LinearGradient(
        colors: [Color(hex: "1B1212"), Color(hex: "2D1B10")],
        startPoint: .top,
        endPoint: .bottom
    )
    private let accentGold = Color(hex: "D4AF37")
    
    var body: some View {
        ZStack {
            bgGradient.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Top Progress Indicator
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        // Step Content
                        switch viewModel.currentStep {
                        case 0:
                            preparationStep
                        case 1:
                            mothersInputStep
                        case 2:
                            shieldResultStep
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.vertical, 20)
                }
                
                // Navigation Buttons
                navigationFooter
            }
            .padding(.top, 10)
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        VStack(spacing: 15) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(10)
                        .background(Circle().fill(.white.opacity(0.1)))
                }
                
                Spacer()
                
                Text("Leitura Geomântica")
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Invisible spacer for balance
                Circle().fill(.clear).frame(width: 38, height: 38)
            }
            .padding(.horizontal)
            
            // Step dots
            HStack(spacing: 12) {
                ForEach(0..<3) { i in
                    Capsule()
                        .fill(viewModel.currentStep >= i ? accentGold : Color.white.opacity(0.2))
                        .frame(width: viewModel.currentStep == i ? 30 : 8, height: 8)
                        .animation(.spring(), value: viewModel.currentStep)
                }
            }
        }
    }
    
    private var preparationStep: some View {
        VStack(spacing: 30) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(accentGold)
                .shadow(color: accentGold.opacity(0.5), radius: 10)
                .padding(.top, 40)
            
            VStack(spacing: 15) {
                Text("Prepare sua intenção")
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                
                Text("Concentre-se em uma pergunta clara e objetiva para o Oráculo da Terra.")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Sua Pergunta:")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(accentGold.opacity(0.8))
                    .padding(.leading, 10)
                
                TextEditor(text: $viewModel.reading.question)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .frame(height: 120)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(accentGold.opacity(0.2), lineWidth: 1))
                    )
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 25)
        }
    }
    
    private var mothersInputStep: some View {
        VStack(spacing: 25) {
            VStack(spacing: 10) {
                Text("As Quatro Mães")
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                
                Text("Toque nos pontos para definir os padrões das quatro figuras iniciais.")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }
            
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
                ForEach(0..<4) { mIndex in
                    VStack(spacing: 12) {
                        Text("Mãe \(mIndex + 1)")
                            .font(.system(size: 14, weight: .black))
                            .foregroundColor(accentGold.opacity(0.8))
                            .tracking(2)
                        
                        // Interactive Figure
                        VStack(spacing: 15) {
                            ForEach(0..<4) { lIndex in
                                Button(action: { viewModel.toggleMotherLine(motherIndex: mIndex, lineIndex: lIndex) }) {
                                    HStack(spacing: 15) {
                                        if viewModel.reading.mothers[mIndex][lIndex] == 1 {
                                            Circle()
                                                .fill(accentGold)
                                                .frame(width: 18, height: 18)
                                                .shadow(color: accentGold.opacity(0.5), radius: 4)
                                        } else {
                                            Circle()
                                                .fill(accentGold)
                                                .frame(width: 18, height: 18)
                                                .shadow(color: accentGold.opacity(0.5), radius: 4)
                                            Circle()
                                                .fill(accentGold)
                                                .frame(width: 18, height: 18)
                                                .shadow(color: accentGold.opacity(0.5), radius: 4)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 28)
                                    .contentShape(Rectangle())
                                }
                            }
                        }
                        .padding(.vertical, 25)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white.opacity(0.04))
                                .overlay(RoundedRectangle(cornerRadius: 24).stroke(accentGold.opacity(0.2), lineWidth: 1))
                        )
                        
                        // Live Name
                        if let figure = viewModel.meaning(for: viewModel.reading.mothers[mIndex]) {
                            Text(figure.name)
                                .font(.system(size: 16, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                                .padding(.top, 4)
                        } else {
                            Text("-")
                                .font(.system(size: 16))
                                .foregroundColor(.clear)
                        }
                    }
                }
            }
            .padding(.horizontal, 25)
        }
    }
    
    private var shieldResultStep: some View {
        VStack(spacing: 30) {
            VStack(spacing: 8) {
                    Text("O Escudo Geomântico")
                        .font(.system(size: 26, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                    
                    if !viewModel.reading.question.isEmpty {
                        Text("\"\(viewModel.reading.question)\"")
                            .font(.system(size: 14, weight: .medium))
                            .italic()
                            .foregroundColor(accentGold.opacity(0.8))
                            .padding(.horizontal, 30)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // The Grid Layout (Shield)
                VStack(spacing: 25) {
                    // M1..M4
                    HStack(spacing: 10) {
                        ForEach(0..<4) { i in
                            ShieldFigureCell(title: "M\(i+1)", pattern: viewModel.reading.mothers[i], viewModel: viewModel)
                        }
                    }
                    
                    // F1..F4
                    HStack(spacing: 10) {
                        ForEach(0..<4) { i in
                            ShieldFigureCell(title: "F\(i+1)", pattern: viewModel.reading.daughters[i], viewModel: viewModel)
                        }
                    }
                    
                    // S1..S4
                    HStack(spacing: 10) {
                        ForEach(0..<4) { i in
                            ShieldFigureCell(title: "S\(i+9)", pattern: viewModel.reading.nieces[i], viewModel: viewModel)
                        }
                    }
                    
                    // Witnesses (Right & Left)
                    HStack(spacing: 30) {
                        ShieldFigureCell(title: "T. Dir. (13)", pattern: viewModel.reading.rightWitness, viewModel: viewModel)
                        ShieldFigureCell(title: "T. Esq. (14)", pattern: viewModel.reading.leftWitness, viewModel: viewModel)
                    }
                    
                    // The Judge and Reconciler
                    HStack(spacing: 40) {
                        ShieldFigureCell(title: "O JUIZ (15)", pattern: viewModel.reading.judge, viewModel: viewModel, isHighlight: true)
                        ShieldFigureCell(title: "RECONCILIADOR", pattern: viewModel.reading.reconciler, viewModel: viewModel, isHighlight: true)
                    }
                }
                .padding(.horizontal, 10)
                
                // Corrupted Reading Warning
                if viewModel.isCorrupted {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text("Aviso de Greer")
                                .font(.system(size: 14, weight: .black))
                        }
                        .foregroundColor(Color.red)
                        
                        Text("Rubeus ou Cauda Draconis apareceu na Casa 1 ou como Juiz. Tradicionalmente, isso indica uma leitura corrompida ou um aviso de grande perigo. Proceda com cautela.")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.red.opacity(0.1)).overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.red.opacity(0.3), lineWidth: 1)))
                    .padding(.horizontal, 25)
                }

                // Way of the Points Hint
                if let judgeHeadOdd = viewModel.reading.judge.first, judgeHeadOdd == 1 {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "point.topleft.down.curvedto.point.bottomright.up")
                            Text("O Caminho dos Pontos")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(accentGold)
                        
                        Text("O Juiz tem uma cabeça ativa (1 ponto). Você pode rastrear a origem deste ponto através do escudo para encontrar a causa raiz da questão.")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(accentGold.opacity(0.05)))
                    .padding(.horizontal, 25)
                }
                
                // Final Verdict Section
                if let judgeMeaning = viewModel.meaning(for: viewModel.reading.judge) {
                    VStack(spacing: 20) {
                        HStack {
                            Rectangle().fill(accentGold.opacity(0.3)).frame(height: 1)
                            Text("JUÍZ")
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(accentGold)
                                .tracking(4)
                            Rectangle().fill(accentGold.opacity(0.3)).frame(height: 1)
                        }
                        
                        VStack(spacing: 12) {
                            Text(judgeMeaning.name)
                                .font(.system(size: 36, weight: .black, design: .serif))
                                .foregroundColor(.white)
                            
                            Text(judgeMeaning.answer)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(accentGold)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Capsule().border(accentGold.opacity(0.5), width: 1))
                        }
                        
                        Text(judgeMeaning.meaning)
                            .font(.system(size: 16, design: .serif))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .lineSpacing(4)
                        
                        HStack(spacing: 15) {
                            BadgeView(text: judgeMeaning.parity, icon: "equal.circle", color: .white.opacity(0.6))
                            BadgeView(text: judgeMeaning.period, icon: judgeMeaning.period == "Diurna" ? "sun.max.fill" : "moon.fill", color: .white.opacity(0.6))
                        }
                    }
                    .padding(.top, 20)
                }
                
                // Reconciler Section
                if let reconcilerMeaning = viewModel.meaning(for: viewModel.reading.reconciler) {
                    VStack(spacing: 15) {
                        HStack {
                            Rectangle().fill(accentGold.opacity(0.1)).frame(height: 1)
                            Text("O RECONCILIADOR")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(accentGold.opacity(0.6))
                                .tracking(2)
                            Rectangle().fill(accentGold.opacity(0.1)).frame(height: 1)
                        }
                        
                        Text("Esta 16ª figura resolve a tensão entre você e o resultado final. Ela aponta para: **\(reconcilerMeaning.name)**.")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 10)
                }
                
                // Advanced Insights (O Zigurate)
                VStack(spacing: 20) {
                    HStack {
                        Rectangle().fill(accentGold.opacity(0.1)).frame(height: 1)
                        Text("INSIGHTS AVANÇADOS")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(accentGold.opacity(0.6))
                            .tracking(2)
                        Rectangle().fill(accentGold.opacity(0.1)).frame(height: 1)
                    }
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            insightBox(title: "Velocidade", value: viewModel.timingVerdict, icon: "clock.fill")
                        }
                        
                        HStack(spacing: 12) {
                            insightBox(title: "Parte da Fortuna", value: "Casa \(viewModel.partOfFortuneHouse)", icon: "sparkles")
                            insightBox(title: "Índice (Espírito)", value: "Casa \(viewModel.spiritIndexHouse)", icon: "bolt.fill")
                        }
                    }
                    .padding(.horizontal, 25)
                }
                .padding(.top, 20)
                
                // Button to see 12 Houses
                Button(action: { isShowingHouses = true }) {
                    HStack {
                        Image(systemName: "house.circle.fill")
                        Text("Explorar as 12 Casas")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(accentGold)
                    .padding(.horizontal, 24)
                    .height(50)
                    .background(
                        Capsule()
                            .stroke(accentGold.opacity(0.5), lineWidth: 1)
                            .background(accentGold.opacity(0.05).clipShape(Capsule()))
                    )
                }
                .padding(.top, 10)
                .padding(.bottom, 40)
            }
            .padding(.top, 10)
            .sheet(isPresented: $isShowingHouses) {
                GeomanciaHousesView(viewModel: viewModel)
            }
    }
    
    private var navigationFooter: some View {
        HStack(spacing: 20) {
            if viewModel.currentStep > 0 {
                Button(action: { viewModel.prevStep() }) {
                    Text("Voltar")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .height(56)
                        .background(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.2), lineWidth: 1))
                }
            }
            
            Button(action: {
                if viewModel.currentStep == 2 {
                    dismiss()
                } else {
                    viewModel.nextStep()
                }
            }) {
                Text(viewModel.currentStep == 2 ? "Finalizar" : "Continuar")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .height(56)
                    .background(RoundedRectangle(cornerRadius: 16).fill(accentGold))
                    .shadow(color: accentGold.opacity(0.3), radius: 10)
            }
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 30)
    }
    
    private func insightBox(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Label(title.uppercased(), systemImage: icon)
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(accentGold.opacity(0.6))
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.04)).overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.1), lineWidth: 1)))
    }
}

// MARK: - Helper Components

struct ShieldFigureCell: View {
    let title: String
    let pattern: [Int]
    let viewModel: GeomanciaReadingViewModel
    var isHighlight: Bool = false
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(isHighlight ? Color(hex: "D4AF37") : .white.opacity(0.4))
            
            VStack(spacing: 6) {
                GeomanticSymbolView(pattern: pattern, color: isHighlight ? Color(hex: "D4AF37") : .white, dotSize: 6, spacing: 6)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isHighlight ? Color(hex: "D4AF37").opacity(0.1) : Color.white.opacity(0.05))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(isHighlight ? Color(hex: "D4AF37").opacity(0.3) : .clear, lineWidth: 1))
            )
            
            if let figure = viewModel.meaning(for: pattern) {
                VStack(spacing: 2) {
                    Text(figure.name)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                    
                    if let planet = figure.planet {
                        Text(planet)
                            .font(.system(size: 7, weight: .medium))
                            .foregroundColor(Color(hex: "D4AF37").opacity(0.6))
                    }
                }
                .lineLimit(1)
            }
        }
        .frame(minWidth: 60)
    }
}

// MARK: - 12 Houses View

struct GeomanciaHousesView: View {
    @ObservedObject var viewModel: GeomanciaReadingViewModel
    @Environment(\.dismiss) var dismiss
    
    // Columns for the houses grid
    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    private let accentGold = Color(hex: "D4AF37")
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "1B1212"), Color(hex: "2D1B10")],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("As 12 Casas")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                        Text("Derrame das Figuras no Destino")
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
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Intro Card
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SOBRE ESTA LEITURA")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(accentGold)
                                .tracking(2)
                            
                            Text("Aqui as primeiras 12 figuras do escudo são distribuídas para detalhar cada área da sua vida em relação à sua pergunta.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .lineSpacing(4)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.03)))
                        .padding(.horizontal, 20)
                        
                        // Grid of Houses
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(viewModel.housesData, id: \.id) { house in
                                Button(action: { viewModel.selectedHouse = house }) {
                                    HouseCard(house: house, pattern: viewModel.figurePattern(forHouse: house.id), viewModel: viewModel)
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Interpretation Tips
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Rectangle().fill(accentGold.opacity(0.3)).frame(height: 1)
                                Text("GUIA DE INTERPRETAÇÃO")
                                    .font(.system(size: 9, weight: .black))
                                    .foregroundColor(accentGold)
                                    .tracking(2)
                                Rectangle().fill(accentGold.opacity(0.3)).frame(height: 1)
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                interpretationRule(icon: "1.circle.fill", title: "Identifique a Casa", desc: "Trabalho (6 e 10), Amor (5 e 7), Magia (8 e 12), Dinheiro (2 e 8).")
                                interpretationRule(icon: "2.circle.fill", title: "Analise a Figura", desc: "Veja se a figura na casa é favorável ou difícil.")
                                interpretationRule(icon: "3.circle.fill", title: "Consulte o Juiz", desc: "O Juiz no Escudo confirma ou nega o que a casa sugere.")
                                interpretationRule(icon: "4.circle.fill", title: "Companhia das Casas", desc: "Casas vizinhas (1-2, 3-4, etc.) trabalham em pares. Repetições nesses pares ligam os assuntos.")
                            }
                        }
                        .padding(25)
                        .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.03)))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .sheet(item: $viewModel.selectedHouse) { house in
            GeomanciaHouseDetailView(house: house, pattern: viewModel.figurePattern(forHouse: house.id), viewModel: viewModel)
        }
    }
    
    private func interpretationRule(icon: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(accentGold)
                .font(.system(size: 18))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                Text(desc)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct HouseCard: View {
    let house: GeomanciaReadingViewModel.HouseDefinition
    let pattern: [Int]
    let viewModel: GeomanciaReadingViewModel
    
    private let accentGold = Color(hex: "D4AF37")
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(house.icon)
                Text("CASA \(house.id)")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(accentGold.opacity(0.8))
                    .tracking(1)
                
                Spacer()
                
                Image(systemName: "arrow.up.right.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(accentGold.opacity(0.3))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8) {
                GeomanticSymbolView(pattern: pattern, color: .white, dotSize: 5, spacing: 5)
                
                if let meaning = viewModel.meaning(for: pattern) {
                    Text(meaning.name)
                        .font(.system(size: 14, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 10)
            
            Text(house.name.replacingOccurrences(of: "Casa \(house.id) — ", with: ""))
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(accentGold)
                .lineLimit(1)
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(accentGold.opacity(0.1), lineWidth: 1))
        )
    }
}

// MARK: - House Detail View

struct GeomanciaHouseDetailView: View {
    let house: GeomanciaReadingViewModel.HouseDefinition
    let pattern: [Int]
    let viewModel: GeomanciaReadingViewModel
    @Environment(\.dismiss) var dismiss
    
    private let accentGold = Color(hex: "D4AF37")
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "2D1B10"), Color(hex: "0F0C08")],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Pull indicator
                    Capsule()
                        .fill(.white.opacity(0.2))
                        .frame(width: 36, height: 5)
                        .padding(.top, 12)
                    
                    // Header Section (House Info)
                    VStack(spacing: 15) {
                        Text(house.icon)
                            .font(.system(size: 50))
                            .padding(20)
                            .background(Circle().fill(accentGold.opacity(0.1)))
                        
                        VStack(spacing: 8) {
                            Text(house.name)
                                .font(.system(size: 24, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("A Área da Vida")
                                .font(.system(size: 12, weight: .black))
                                .foregroundColor(accentGold.opacity(0.6))
                                .tracking(2)
                            
                            BadgeView(text: house.quality, icon: "gauge.with.needle", color: .white.opacity(0.6))
                                .padding(.top, 5)
                        }
                        
                        Text(house.description)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.top, 20)
                    
                    // Figure Section
                    if let figureMeaning = viewModel.meaning(for: pattern) {
                        VStack(spacing: 25) {
                            HStack {
                                Rectangle().fill(accentGold.opacity(0.2)).frame(height: 1)
                                Text("A FIGURA NA CASA")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(accentGold.opacity(0.8))
                                    .tracking(3)
                                Rectangle().fill(accentGold.opacity(0.2)).frame(height: 1)
                            }
                            
                            VStack(spacing: 20) {
                                GeomanticSymbolView(pattern: pattern, color: accentGold, dotSize: 12, spacing: 15)
                                    .padding(25)
                                    .background(Circle().fill(Color.white.opacity(0.03)).overlay(Circle().stroke(accentGold.opacity(0.1), lineWidth: 1)))
                                
                                VStack(spacing: 5) {
                                    Text(figureMeaning.name)
                                        .font(.system(size: 32, weight: .bold, design: .serif))
                                        .foregroundColor(.white)
                                }
                                
                                HStack(spacing: 12) {
                                    BadgeView(text: figureMeaning.element, icon: "drop.fill", color: accentGold.opacity(0.8))
                                    BadgeView(text: figureMeaning.nature, icon: "scope", color: accentGold.opacity(0.8))
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 20) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("ESSÊNCIA DA FIGURA")
                                        .font(.system(size: 12, weight: .black))
                                        .foregroundColor(accentGold.opacity(0.5))
                                    Text(figureMeaning.meaning)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white.opacity(0.9))
                                }
                            }
                            .padding(25)
                            .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.03)))
                        }
                        .padding(.horizontal, 25)
                    }
                    
                    Button(action: { dismiss() }) {
                        Text("Fechar Detalhes")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .height(56)
                            .background(RoundedRectangle(cornerRadius: 16).fill(accentGold))
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 30)
                }
            }
        }
    }
}

#Preview {
    GeomanciaReadingView()
}
