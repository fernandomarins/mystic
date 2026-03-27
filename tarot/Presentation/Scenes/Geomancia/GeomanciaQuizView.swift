//
//  GeomanciaQuizView.swift
//  tarot
//
//  Created by Antigravity on 17/01/26.
//

import SwiftUI

struct GeomanciaQuizView: View {
    @ObservedObject var viewModel: GeomanciaViewModel
    @Environment(\.dismiss) var dismiss
    
    enum QuestionType: CaseIterable {
        case nameFromSymbol
        case symbolFromName
        case keywordFromName
        case meaningFromName
    }
    
    struct Question {
        let type: QuestionType
        let correctFigure: GeomanciaMeaning
        let options: [GeomanciaMeaning]
    }
    
    @State private var currentQuestion: Question?
    @State private var score = 0
    @State private var questionsAnswered = 0
    @State private var selectedOptionId: Int?
    @State private var showFeedback = false
    @State private var isCorrect = false
    @State private var quizFinished = false
    
    private let totalQuestions = 50
    private let accentGold = Color(hex: "D4AF37")
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "1B1212"), Color(hex: "2D1B10")],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            if quizFinished {
                resultView
            } else if let question = currentQuestion {
                quizContentView(question: question)
            } else {
                ProgressView().tint(accentGold)
            }
        }
        .onAppear {
            generateQuestion()
        }
    }
    
    // MARK: - Quiz Content
    
    private func quizContentView(question: Question) -> some View {
        VStack(spacing: 30) {
            // Progress Header
            HStack {
                Text("Questão \(questionsAnswered + 1) de \(totalQuestions)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(accentGold.opacity(0.8))
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.3))
                }
            }
            .padding(.horizontal, 25)
            .padding(.top, 20)
            
            // Question Box
            VStack(spacing: 20) {
                Text(questionText(for: question.type))
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                if question.type == .nameFromSymbol {
                    GeomanticSymbolView(pattern: question.correctFigure.pattern, color: accentGold, dotSize: 12, spacing: 12)
                        .padding(30)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.05))
                                .overlay(Circle().stroke(accentGold.opacity(0.2), lineWidth: 1))
                        )
                } else if question.type == .symbolFromName || question.type == .keywordFromName || question.type == .meaningFromName {
                    Text(question.correctFigure.name.uppercased())
                        .font(.system(size: 36, weight: .black, design: .serif))
                        .foregroundColor(accentGold)
                        .shadow(color: accentGold.opacity(0.3), radius: 10)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(RoundedRectangle(cornerRadius: 32).fill(Color.white.opacity(0.03)))
            .padding(.horizontal, 20)
            
            // Options
            VStack(spacing: 12) {
                ForEach(question.options) { option in
                    optionButton(option: option, question: question)
                }
            }
            .padding(.horizontal, 25)
            
            Spacer()
            
            // Next Button
            if showFeedback {
                Button(action: nextQuestion) {
                    Text(questionsAnswered + 1 == totalQuestions ? "Ver Resultado" : "Próxima Questão")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .height(60)
                        .background(RoundedRectangle(cornerRadius: 16).fill(accentGold))
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
    private func optionButton(option: GeomanciaMeaning, question: Question) -> some View {
        Button(action: {
            if !showFeedback {
                selectOption(option, in: question)
            }
        }) {
            HStack {
                if question.type == .symbolFromName {
                    GeomanticSymbolView(pattern: option.pattern, color: optionTextColor(option), dotSize: 8, spacing: 8)
                        .frame(maxWidth: .infinity)
                } else {
                    Text(optionText(for: option, type: question.type))
                        .font(.system(size: question.type == .meaningFromName ? 13 : 16, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                }
                
                if question.type != .symbolFromName {
                    Spacer()
                }
                
                if showFeedback {
                    if option.id == question.correctFigure.id {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    } else if option.id == selectedOptionId {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal, question.type == .symbolFromName ? 10 : 20)
            .padding(.vertical, 16)
            .frame(minHeight: 80)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(optionBackgroundColor(option, correctId: question.correctFigure.id))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(optionStrokeColor(option, correctId: question.correctFigure.id), lineWidth: 2)
                    )
            )
            .foregroundColor(optionTextColor(option))
        }
        .disabled(showFeedback)
    }
    
    // MARK: - Result View
    
    private var resultView: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 20) {
                Text(score >= 7 ? "Excelente!" : "Bom Trabalho!")
                    .font(.system(size: 40, weight: .bold, design: .serif))
                    .foregroundColor(accentGold)
                
                ZStack {
                    Circle()
                        .stroke(accentGold.opacity(0.1), lineWidth: 20)
                        .frame(width: 200, height: 200)
                    
                    VStack {
                        Text("\(score)")
                            .font(.system(size: 72, weight: .black))
                            .foregroundColor(.white)
                        Text("DE \(totalQuestions)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(accentGold.opacity(0.6))
                    }
                }
            }
            
            Text(feedbackMessage)
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: restartQuiz) {
                Text("Tentar Novamente")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .height(60)
                    .background(RoundedRectangle(cornerRadius: 16).fill(accentGold))
            }
            .padding(.horizontal, 40)
            
            Button(action: { dismiss() }) {
                Text("Voltar ao Início")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.bottom, 30)
        }
    }
    
    // MARK: - Helper Methods
    
    private func questionText(for type: QuestionType) -> String {
        switch type {
        case .nameFromSymbol: return "Qual o nome desta figura?"
        case .symbolFromName: return "Qual o símbolo desta figura?"
        case .keywordFromName: return "Qual a palavra-chave desta figura?"
        case .meaningFromName: return "Qual o sentido tradicional desta figura?"
        }
    }
    
    private func optionText(for figure: GeomanciaMeaning, type: QuestionType) -> String {
        switch type {
        case .nameFromSymbol: return figure.name
        case .symbolFromName: return "" // Handled by symbol view
        case .keywordFromName: return figure.keyword ?? "???"
        case .meaningFromName: return figure.meaning
        }
    }
    
    private func selectOption(_ option: GeomanciaMeaning, in question: Question) {
        selectedOptionId = option.id
        isCorrect = option.id == question.correctFigure.id
        if isCorrect {
            score += 1
        }
        withAnimation {
            showFeedback = true
        }
    }
    
    private func nextQuestion() {
        questionsAnswered += 1
        if questionsAnswered < totalQuestions {
            generateQuestion()
            selectedOptionId = nil
            showFeedback = false
        } else {
            withAnimation {
                quizFinished = true
            }
        }
    }
    
    private func generateQuestion() {
        let allFigures = viewModel.forms
        guard !allFigures.isEmpty else { return }
        
        let type = QuestionType.allCases.randomElement()!
        let correct = allFigures.randomElement()!
        
        var options = allFigures.filter { $0.id != correct.id }.shuffled().prefix(3)
        options.append(correct)
        
        currentQuestion = Question(type: type, correctFigure: correct, options: options.shuffled())
    }
    
    private func restartQuiz() {
        score = 0
        questionsAnswered = 0
        selectedOptionId = nil
        showFeedback = false
        quizFinished = false
        generateQuestion()
    }
    
    private func optionBackgroundColor(_ option: GeomanciaMeaning, correctId: Int) -> Color {
        if showFeedback {
            if option.id == correctId {
                return Color.green.opacity(0.2)
            } else if option.id == selectedOptionId {
                return Color.red.opacity(0.2)
            }
        }
        return Color.white.opacity(0.05)
    }
    
    private func optionStrokeColor(_ option: GeomanciaMeaning, correctId: Int) -> Color {
        if showFeedback {
            if option.id == correctId {
                return Color.green.opacity(0.5)
            } else if option.id == selectedOptionId {
                return Color.red.opacity(0.5)
            }
        }
        return Color.clear
    }
    
    private func optionTextColor(_ option: GeomanciaMeaning) -> Color {
        if showFeedback {
            if option.id == selectedOptionId || option.id == currentQuestion?.correctFigure.id {
                return .white
            }
            return .white.opacity(0.3)
        }
        return .white
    }
    
    private var feedbackMessage: String {
        if score == totalQuestions {
            return "Perfeito! Você dominou a arte das figuras geomânticas."
        } else if score >= 7 {
            return "Muito bem! Você já tem um conhecimento sólido sobre a terra."
        } else {
            return "Continue praticando. A familiaridade com as figuras é a base da geomancia."
        }
    }
}
