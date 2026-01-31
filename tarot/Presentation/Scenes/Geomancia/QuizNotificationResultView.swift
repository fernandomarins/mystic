//
//  QuizNotificationResultView.swift
//  tarot
//
//  Created by Antigravity on 29/01/26.
//

import SwiftUI

struct QuizNotificationResultView: View {
    let result: QuizResult
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = GeomanciaViewModel()
    
    private let accentGold = Color(hex: "D4AF37")
    private let bgGradient = LinearGradient(
        colors: [Color(hex: "1B1212"), Color(hex: "2D1B10")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    var figure: GeomanciaMeaning? {
        viewModel.forms.first(where: { $0.id == result.figureId })
    }
    
    var body: some View {
        ZStack {
            bgGradient.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    Spacer().frame(height: 20)
                    
                    // Result Icon
                    ZStack {
                        Circle()
                            .fill(result.isCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: result.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(result.isCorrect ? .green : .red)
                    }
                    
                    // Result Text
                    Text(result.isCorrect ? "Resposta Correta!" : "Resposta Incorreta")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                    
                    // Question
                    VStack(alignment: .leading, spacing: 12) {
                        Text("PERGUNTA")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(accentGold.opacity(0.7))
                            .tracking(2)
                        
                        Text(result.question)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                    )
                    .padding(.horizontal, 20)
                    
                    // Answers
                    VStack(alignment: .leading, spacing: 16) {
                        // User Answer
                        HStack(spacing: 12) {
                            Image(systemName: result.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(result.isCorrect ? .green : .red)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Sua Resposta")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Text(result.userAnswer)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(result.isCorrect ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(result.isCorrect ? Color.green.opacity(0.3) : Color.red.opacity(0.3), lineWidth: 1)
                                )
                        )
                        
                        // Correct Answer (only if wrong)
                        if !result.isCorrect {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Resposta Correta")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                    Text(result.correctAnswer)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.green.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Figure Details (if available)
                    if let figure = figure {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("SOBRE A FIGURA")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(accentGold.opacity(0.7))
                                .tracking(2)
                            
                            // Symbol
                            GeomanticSymbolView(pattern: figure.pattern, color: accentGold, dotSize: 12, spacing: 12)
                                .frame(height: 100)
                                .frame(maxWidth: .infinity)
                            
                            // Name
                            VStack(spacing: 4) {
                                Text(figure.name)
                                    .font(.system(size: 24, weight: .bold, design: .serif))
                                    .foregroundColor(accentGold)
                                
                                Text(figure.latinName)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Key info
                            if let keyword = figure.keyword {
                                HStack {
                                    Text("Palavra-chave:")
                                        .foregroundColor(.white.opacity(0.6))
                                    Spacer()
                                    Text(keyword)
                                        .foregroundColor(accentGold)
                                        .fontWeight(.bold)
                                }
                                .font(.system(size: 14))
                            }
                            
                            if let planet = figure.planet {
                                HStack {
                                    Text("Planeta:")
                                        .foregroundColor(.white.opacity(0.6))
                                    Spacer()
                                    Text(planet)
                                        .foregroundColor(accentGold)
                                        .fontWeight(.bold)
                                }
                                .font(.system(size: 14))
                            }
                            
                            HStack {
                                Text("Elemento:")
                                    .foregroundColor(.white.opacity(0.6))
                                Spacer()
                                Text(figure.element)
                                    .foregroundColor(accentGold)
                                    .fontWeight(.bold)
                            }
                            .font(.system(size: 14))
                            
                            Divider()
                                .background(accentGold.opacity(0.3))
                            
                            Text(figure.meaning)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(4)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.05))
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer().frame(height: 20)
                }
            }
            
            // Continue Button
            VStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Text("Continuar")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .height(56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(accentGold)
                                .shadow(color: accentGold.opacity(0.3), radius: 10, y: 5)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            viewModel.fetchForms()
        }
    }
}
