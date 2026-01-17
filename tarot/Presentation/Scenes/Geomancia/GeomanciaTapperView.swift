//
//  GeomanciaTapperView.swift
//  tarot
//
//  Created by Antigravity on 16/01/26.
//

import SwiftUI

struct GeomanciaTapperView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = GeomanciaReadingViewModel()
    
    // Tapper State
    @State private var mode: TapMode = .singleFigure
    @State private var tapCount: Int = 0
    @State private var currentLine: Int = 0
    @State private var currentFigureLines: [Int] = []
    @State private var generatedMothers: [[Int]] = []
    
    // UI State
    @State private var showResult = false
    @State private var showDetail = false
    @State private var selectedMeaning: GeomanciaMeaning?
    @State private var isAnimatingTap = false
    
    // For "Reading" mode transition
    @State private var navigateToReading = false
    
    enum TapMode {
        case singleFigure
        case reading // 4 Figures
        
        var title: String {
            switch self {
            case .singleFigure: return "Gerar 1 Figura"
            case .reading: return "Gerar 4 Figuras (Mães)"
            }
        }
    }
    
    // Theme Colors
    private let bgGradient = LinearGradient(
        colors: [Color(hex: "1B1212"), Color(hex: "2D1B10")],
        startPoint: .top,
        endPoint: .bottom
    )
    private let accentGold = Color(hex: "D4AF37")
    
    var body: some View {
        ZStack {
            // Background
            bgGradient.ignoresSafeArea()
            
            VStack {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    Spacer()
                    Text("Sortilégio Geomântico")
                        .font(.system(size: 16, weight: .bold, design: .serif))
                        .foregroundColor(accentGold)
                    Spacer()
                    // Mode Toggle (Only if not started)
                    if generatedMothers.isEmpty && currentFigureLines.isEmpty {
                        Menu {
                            Button("Apenas 1 Figura") { mode = .singleFigure }
                            Button("Leitura Completa (4 Figuras)") { mode = .reading }
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 20))
                                .foregroundColor(accentGold)
                        }
                    } else {
                        Spacer().frame(width: 24)
                    }
                }
                .padding()
                
                // Progress Indicator
                if mode == .reading {
                    HStack(spacing: 8) {
                        ForEach(0..<4) { i in
                            Circle()
                                .fill(i < generatedMothers.count ? accentGold : (i == generatedMothers.count ? accentGold.opacity(0.3) : Color.white.opacity(0.1)))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.bottom, 20)
                    .animation(.default, value: generatedMothers.count)
                }
                
                // Title & Instructions
                VStack(spacing: 8) {
                    Text(mode == .reading ? "Figura \(generatedMothers.count + 1) de 4" : "Gerando Figura de Poder")
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                    
                    Text("Concentre-se na questão e toque repetidamente.\nO número de toques (par ou ímpar) define a pontuação.")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Tap Area
                ZStack {
                    Circle()
                        .stroke(accentGold.opacity(0.2), lineWidth: 1)
                        .frame(width: 280, height: 280)
                    
                    Circle()
                        .fill(Color.white.opacity(0.02))
                        .frame(width: 250, height: 250)
                        
                    VStack(spacing: 10) {
                        Image(systemName: "hand.tap")
                            .font(.system(size: 60))
                            .foregroundColor(accentGold.opacity(isAnimatingTap ? 1.0 : 0.5))
                            .scaleEffect(isAnimatingTap ? 1.2 : 1.0)
                        
                        Text("TOQUE")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(accentGold.opacity(0.5))
                            .tracking(2)
                    }
                }
                .contentShape(Circle())
                .onTapGesture {
                    tap()
                }
                
                Spacer()
                
                // Current Figure Progress (Lines)
                HStack(spacing: 15) {
                    ForEach(0..<4) { i in
                        VStack(spacing: 4) {
                            if i < currentFigureLines.count {
                                // Completed Line
                                let val = currentFigureLines[i]
                                Circle().fill(accentGold).frame(width: 6, height: 6)
                                if val == 2 {
                                    Circle().fill(accentGold).frame(width: 6, height: 6)
                                }
                            } else if i == currentFigureLines.count {
                                // Current Active Line
                                Circle().stroke(accentGold, lineWidth: 1).frame(width: 6, height: 6)
                                Text("?")
                                    .font(.system(size: 10))
                                    .foregroundColor(accentGold.opacity(0.5))
                            } else {
                                // Future Line
                                Circle().fill(Color.white.opacity(0.1)).frame(width: 4, height: 4)
                            }
                        }
                        .frame(width: 20, height: 40)
                    }
                }
                .padding(.bottom, 30)
                
                // Confirm Button
                Button(action: confirmLine) {
                    Text(tapCount > 0 ? "Confirmar Linha \(currentFigureLines.count + 1)" : "Toque para Começar")
                        .font(.headline)
                        .foregroundColor(tapCount > 0 ? .black : .white.opacity(0.3))
                        .frame(maxWidth: .infinity)
                        .height(56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(tapCount > 0 ? accentGold : Color.white.opacity(0.05))
                        )
                }
                .disabled(tapCount == 0)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        // Result Sheet (Single Mode)
        .sheet(isPresented: $showDetail) {
            if let meaning = selectedMeaning {
                GeomanciaDetailView(item: meaning)
            }
        }
        // Transition to Reading View (Reading Mode)
        .fullScreenCover(isPresented: $navigateToReading) {
            // We need to initialize the ReadingView with our generated mothers
            // For now w e pass a closure or inject into a shared VM, but here we'll pass via init if we update ReadingView
            GeomanciaReadingView(initialMothers: generatedMothers)
        }
    }
    
    // MARK: - Logic
    
    private func tap() {
        tapCount += 1
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            isAnimatingTap = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isAnimatingTap = false
        }
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    private func confirmLine() {
        guard tapCount > 0 else { return }
        
        // Geomancy Logic: Odd = 1 dot (1), Even = 2 dots (2)
        let points = (tapCount % 2 == 0) ? 2 : 1
        
        withAnimation {
            currentFigureLines.append(points)
            tapCount = 0 // Reset for next line
        }
        
        if currentFigureLines.count == 4 {
            // Figure Completed
            finishFigure()
        }
    }
    
    private func finishFigure() {
        let completedFigure = currentFigureLines
        
        if mode == .singleFigure {
            // Show result immediately
            if let meaning = viewModel.meaning(for: completedFigure) {
                selectedMeaning = meaning
                showDetail = true
                // Reset after showing
                currentFigureLines = []
            }
        } else {
            // Reading Mode: Store and continue
            generatedMothers.append(completedFigure)
            currentFigureLines = []
            
            if generatedMothers.count == 4 {
                // All 4 Mothers generated
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    navigateToReading = true
                }
            }
        }
    }
}
