//
//  GeomanciaReadingView.swift
//  tarot
//
//  Created by Antigravity on 15/01/26.
//

import SwiftUI
import CoreGraphics

struct GeomanciaReadingView: View {
    @StateObject private var viewModel = GeomanciaReadingViewModel()
    var initialMothers: [[Int]]? = nil // Optional initial data
    
    @Environment(\.dismiss) var dismiss
    @State private var isShowingHouses = false
    @State private var isShowingInsights = false
    @State private var selectedMeaning: GeomanciaMeaning?
    @State private var showCopyConfirmation = false
    @State private var isShowingPDFPreview = false
    @State private var isShowingPerfection = false
    @State private var isShowingHouseSum = false
    
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
        .onAppear {
            if let mothers = initialMothers {
                // If provided with mothers, set them and jump to Shield Step
                viewModel.reading.mothers = mothers
                viewModel.currentStep = 2
            }
        }
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
                            ShieldFigureCell(
                                title: "M\(i+1)",
                                pattern: viewModel.reading.mothers[i],
                                viewModel: viewModel,
                                onTap: { meaning in selectedMeaning = meaning }
                            )
                        }
                    }
                    
                    // F1..F4
                    HStack(spacing: 10) {
                        ForEach(0..<4) { i in
                            ShieldFigureCell(
                                title: "F\(i+1)",
                                pattern: viewModel.reading.daughters[i],
                                viewModel: viewModel,
                                onTap: { meaning in selectedMeaning = meaning }
                            )
                        }
                    }
                    
                    // S1..S4
                    HStack(spacing: 10) {
                        ForEach(0..<4) { i in
                            ShieldFigureCell(
                                title: "S\(i+9)",
                                pattern: viewModel.reading.nieces[i],
                                viewModel: viewModel,
                                onTap: { meaning in selectedMeaning = meaning }
                            )
                        }
                    }
                    
                    // Witnesses (Left & Right)
                    HStack(spacing: 30) {
                        ShieldFigureCell(
                            title: "T. Esq. (14)",
                            pattern: viewModel.reading.leftWitness,
                            viewModel: viewModel,
                            onTap: { meaning in selectedMeaning = meaning }
                        )
                        ShieldFigureCell(
                            title: "T. Dir. (13)",
                            pattern: viewModel.reading.rightWitness,
                            viewModel: viewModel,
                            onTap: { meaning in selectedMeaning = meaning }
                        )
                    }
                    
                    // The Judge and Reconciler
                    HStack(spacing: 40) {
                        ShieldFigureCell(
                            title: "O JUIZ (15)",
                            pattern: viewModel.reading.judge,
                            viewModel: viewModel,
                            isHighlight: true,
                            onTap: { meaning in selectedMeaning = meaning }
                        )
                        ShieldFigureCell(
                            title: "RECONCILIADOR",
                            pattern: viewModel.reading.reconciler,
                            viewModel: viewModel,
                            isHighlight: true,
                            onTap: { meaning in selectedMeaning = meaning }
                        )
                    }
                }
                .padding(.horizontal, 10)
                
                // Corrupted Reading Warning
                if viewModel.isCorrupted {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text("Aviso")
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
                    Button(action: { selectedMeaning = judgeMeaning }) {
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
                
                // Action Buttons
                VStack(spacing: 15) {
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
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule()
                                .stroke(accentGold.opacity(0.5), lineWidth: 1)
                                .background(accentGold.opacity(0.05).clipShape(Capsule()))
                        )
                    }
                    
                    // Button for Advanced Insights
                    Button(action: { isShowingInsights = true }) {
                        HStack {
                            Image(systemName: "sparkles.rectangle.stack.fill")
                            Text("Insights Avançados")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 24)
                        .height(50)
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule()
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                                .background(Color.white.opacity(0.05).clipShape(Capsule()))
                        )
                    }
                    
                    // Button for Perfection Checker
                    Button(action: { isShowingPerfection = true }) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                            Text("Verificar Perfeição")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 24)
                        .height(50)
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule()
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                                .background(Color.white.opacity(0.05).clipShape(Capsule()))
                        )
                    }
                    
                    // Button for House Sum Calculator
                    Button(action: { isShowingHouseSum = true }) {
                        HStack {
                            Image(systemName: "plus.forwardslash.minus")
                            Text("Soma de Casas")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 24)
                        .height(50)
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule()
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                                .background(Color.white.opacity(0.05).clipShape(Capsule()))
                        )
                    }
                    
                    // Button to Export Summary
                    Button(action: {
                        UIPasteboard.general.string = viewModel.exportReadingSummary()
                        withAnimation { showCopyConfirmation = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { showCopyConfirmation = false }
                        }
                    }) {
                        HStack {
                            Image(systemName: showCopyConfirmation ? "checkmark" : "doc.on.doc")
                            Text(showCopyConfirmation ? "Copiado!" : "Copiar Resumo")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 24)
                        .height(50)
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule()
                                .stroke(.white.opacity(0.1), lineWidth: 1)
                                .background(Color.white.opacity(0.02).clipShape(Capsule()))
                        )
                    }
                }
                
                // Button to Export PDF
                if #available(iOS 16.0, *) {
                    Button(action: { isShowingPDFPreview = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Exportar PDF (Mapa)")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 24)
                        .height(50)
                        .frame(maxWidth: .infinity)
                        .background(
                            Capsule()
                                .fill(Color(hex: "D4AF37").opacity(0.8))
                                .shadow(color: Color(hex: "D4AF37").opacity(0.2), radius: 5, y: 2)
                        )
                    }
                    .sheet(isPresented: $isShowingPDFPreview) {
                        // Preview Sheet with Share
                        NavigationView {
                            VStack {
                                GeomanciaPDFView(reading: viewModel.reading, viewModel: viewModel)
                                    .scaleEffect(0.6)
                                    .frame(width: 360, height: 500)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                
                                Spacer()
                                
                                ShareLink(item: renderPDF(), preview: SharePreview("Leitura Geomântica", image: Image(systemName: "scroll.fill"))) {
                                    Label("Compartilhar PDF", systemImage: "square.and.arrow.up")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .height(50)
                                        .background(Capsule().fill(Color(hex: "D4AF37")))
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
                        }
                    }
                }
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
            .padding(.bottom, 40)
            .padding(.top, 10)
            .sheet(isPresented: $isShowingHouses) {
                GeomanciaHousesView(viewModel: viewModel)
            }
            .sheet(isPresented: $isShowingInsights) {
                GeomanciaInsightsView(viewModel: viewModel)
            }
            .sheet(isPresented: $isShowingPerfection) {
                GeomanciaPerfectionView(viewModel: viewModel)
            }
            .sheet(isPresented: $isShowingHouseSum) {
                GeomanciaHouseSumView(viewModel: viewModel)
            }
            .sheet(item: $selectedMeaning) { meaning in
                GeomanciaDetailView(item: meaning)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
            .overlay(
                Group {
                    if showCopyConfirmation {
                        VStack {
                            Spacer()
                            Text("Resumo copiado!")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Capsule().fill(Color(hex: "D4AF37")))
                                .shadow(radius: 10)
                                .padding(.bottom, 100)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                        .zIndex(100)
                    }
                }
            )
            .sheet(isPresented: $isShowingPDFPreview) {
                // Preview Sheet with Share
                NavigationView {
                    VStack {
                        GeomanciaPDFView(reading: viewModel.reading, viewModel: viewModel)
                            .scaleEffect(0.6)
                            .frame(width: 360, height: 500)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        
                        Spacer()
                        
                        ShareLink(item: renderPDF(), preview: SharePreview("Leitura Geomântica", image: Image(systemName: "scroll.fill"))) {
                            Label("Compartilhar PDF", systemImage: "square.and.arrow.up")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .height(50)
                                .background(Capsule().fill(Color(hex: "D4AF37")))
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
                }
            }
    }
    
    // PDF Rendering Helper
    @MainActor
    @available(iOS 16.0, *)
    private func renderPDF() -> URL {
        let renderer = ImageRenderer(content: GeomanciaPDFView(reading: viewModel.reading, viewModel: viewModel))
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("leitura_geomancia.pdf")
        
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
    
}

// MARK: - Helper Components

struct ShieldFigureCell: View {
    let title: String
    let pattern: [Int]
    let viewModel: GeomanciaReadingViewModel
    var isHighlight: Bool = false
    var onTap: ((GeomanciaMeaning) -> Void)?
    
    var body: some View {
        Button(action: {
            if let meaning = viewModel.meaning(for: pattern) {
                onTap?(meaning)
            }
        }) {
            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(isHighlight ? Color(hex: "D4AF37") : .white.opacity(0.4))
                
                VStack(spacing: 6) {
                    GeomanticSymbolView(pattern: pattern, color: isHighlight ? Color(hex: "D4AF37") : .white, dotSize: 6, spacing: 6)
                }
                .padding(10)
                .frame(maxWidth: .infinity)
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
        } // End Button
        .buttonStyle(PlainButtonStyle())
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
                    HStack(spacing: 6) {
                        Text(meaning.name)
                            .font(.system(size: 14, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                        
                        // Strength/Weakness indicators
                        if let strengthened = meaning.strengthenedHouses, strengthened.contains(house.id) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.yellow)
                                .shadow(color: .yellow.opacity(0.5), radius: 2)
                        } else if let weakened = meaning.weakenedHouses, weakened.contains(house.id) {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.red.opacity(0.8))
                        }
                    }
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
                                    
                                    if let keyword = figureMeaning.keyword {
                                        Text(keyword.uppercased())
                                            .font(.system(size: 14, weight: .black))
                                            .foregroundColor(accentGold.opacity(0.6))
                                            .tracking(4)
                                    }
                                }
                                
                                HStack(spacing: 12) {
                                    BadgeView(text: figureMeaning.element, icon: "drop.fill", color: accentGold.opacity(0.8))
                                    BadgeView(text: figureMeaning.nature, icon: "scope", color: accentGold.opacity(0.8))
                                }
                            }
                            
                            // House Compatibility Section
                            if let strengthened = figureMeaning.strengthenedHouses, strengthened.contains(house.id) {
                                compatibilityBadge(title: "FIGURA FORTALECIDA", desc: "Nesta casa, a essência da figura se expressa com máxima harmonia e poder.", color: .yellow)
                            } else if let weakened = figureMeaning.weakenedHouses, weakened.contains(house.id) {
                                compatibilityBadge(title: "FIGURA ENFRAQUECIDA", desc: "Nesta casa, a figura encontra resistência ou dificuldade em manifestar seu potencial positivo.", color: .red)
                            }
                            
                            VStack(alignment: .leading, spacing: 25) {
                                // Basic Meaning
                                detailSection(title: "ESSÊNCIA DA FIGURA", text: figureMeaning.meaning)
                                
                                // Detailed Divinatory Meaning
                                if let divMeaning = figureMeaning.divinatoryMeaning {
                                    detailSection(title: "SIGNIFICADO DIVINATÓRIO", text: divMeaning)
                                }
                                
                                // Physical & Character
                                if let body = figureMeaning.bodyType {
                                    detailSection(title: "TIPO FÍSICO / APARÊNCIA", text: body)
                                }
                                
                                if let character = figureMeaning.characterType {
                                    detailSection(title: "TEMPERAMENTO / CARÁTER", text: character)
                                }
                                
                                // Correspondences Grid
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("CORRESPONDÊNCIAS")
                                        .font(.system(size: 12, weight: .black))
                                        .foregroundColor(accentGold.opacity(0.5))
                                    
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                        if let anatomy = figureMeaning.anatomy {
                                            miniInfoCell(title: "Anatomia", text: anatomy, icon: "figure.human")
                                        }
                                        if let color = figureMeaning.color {
                                            miniInfoCell(title: "Cor", text: color, icon: "paintpalette")
                                        }
                                        if let outer = figureMeaning.outerElement {
                                            miniInfoCell(title: "Elemento Ext.", text: outer, icon: "sparkles")
                                        }
                                        if let inner = figureMeaning.innerElement {
                                            miniInfoCell(title: "Elemento Int.", text: inner, icon: "bolt.fill")
                                        }
                                    }
                                }
                                
                                // Commentary
                                if let commentary = figureMeaning.commentary {
                                    detailSection(title: "COMENTÁRIO ESOTÉRICO", text: commentary)
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
    
    // MARK: - Helper Subviews
    
    private func compatibilityBadge(title: String, desc: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: color == .yellow ? "crown.fill" : "arrow.down.circle.fill")
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(color)
                    .tracking(1)
            }
            
            Text(desc)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(4)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.1))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(color.opacity(0.2), lineWidth: 1))
        )
        .padding(.horizontal, 25)
    }
    
    private func detailSection(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 12, weight: .black))
                .foregroundColor(accentGold.opacity(0.5))
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
    }
    
    private func miniInfoCell(title: String, text: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(accentGold)
                .frame(width: 32, height: 32)
                .background(Circle().fill(accentGold.opacity(0.1)))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white.opacity(0.4))
                Text(text)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.04)))
    }
}

#Preview {
    GeomanciaReadingView()
}
