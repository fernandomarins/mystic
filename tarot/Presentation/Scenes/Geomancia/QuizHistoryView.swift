//
//  QuizHistoryView.swift
//  tarot
//
//  Created by Antigravity on 30/01/26.
//

import SwiftUI
import SwiftData

struct QuizHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \QuizResultEntity.timestamp, order: .reverse) private var allResults: [QuizResultEntity]
    
    @State private var filter: FilterOption = .all
    @State private var selectedResult: QuizResult? = nil
    @State private var showDetail: Bool = false
    
    private let accentGold = Color(hex: "D4AF37")
    private let bgGradient = LinearGradient(
        colors: [Color(hex: "1B1212"), Color(hex: "2D1B10")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    enum FilterOption: String, CaseIterable {
        case all = "Todos"
        case correct = "Acertos"
        case incorrect = "Erros"
    }
    
    private var filteredResults: [QuizResultEntity] {
        switch filter {
        case .all:
            return allResults
        case .correct:
            return allResults.filter { $0.isCorrect }
        case .incorrect:
            return allResults.filter { !$0.isCorrect }
        }
    }
    
    private var correctCount: Int {
        allResults.filter { $0.isCorrect }.count
    }
    
    private var correctRate: Double {
        guard !allResults.isEmpty else { return 0 }
        return Double(correctCount) / Double(allResults.count) * 100
    }
    
    var body: some View {
        ZStack {
            bgGradient.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Stats Header
                VStack(spacing: 16) {
                    Text("Histórico de Quizzes")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                    
                    // Stats Cards
                    HStack(spacing: 12) {
                        StatCard(
                            title: "Total",
                            value: "\(allResults.count)",
                            icon: "list.bullet.circle.fill",
                            color: accentGold
                        )
                        
                        StatCard(
                            title: "Acertos",
                            value: "\(correctCount)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        
                        StatCard(
                            title: "Taxa",
                            value: String(format: "%.0f%%", correctRate),
                            icon: "chart.line.uptrend.xyaxis.circle.fill",
                            color: correctRate >= 70 ? .green : (correctRate >= 50 ? .orange : .red)
                        )
                    }
                    .padding(.horizontal)
                    
                    // Filter Picker
                    Picker("Filtro", selection: $filter) {
                        ForEach(FilterOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }
                .padding(.vertical, 20)
                .background(Color.black.opacity(0.2))
                
                // Results List
                if filteredResults.isEmpty {
                    EmptyStateView(filter: filter)
                } else {
                    List {
                        ForEach(groupedResults.keys.sorted(by: >), id: \.self) { date in
                            Section(header: Text(sectionTitle(for: date))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(accentGold)
                            ) {
                                ForEach(groupedResults[date] ?? []) { result in
                                    QuizHistoryRow(result: result, accentGold: accentGold)
                                        .listRowBackground(Color.white.opacity(0.05))
                                        .listRowSeparator(.hidden)
                                        .onTapGesture {
                                            selectedResult = QuizResult(
                                                question: result.question,
                                                correctAnswer: result.correctAnswer,
                                                userAnswer: result.userAnswer,
                                                isCorrect: result.isCorrect,
                                                figureId: result.figureId,
                                                timestamp: result.timestamp
                                            )
                                            showDetail = true
                                        }
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showDetail) {
            if let result = selectedResult {
                QuizNotificationResultView(result: result)
            }
        }
    }
    
    private var groupedResults: [Date: [QuizResultEntity]] {
        Dictionary(grouping: filteredResults) { result in
            Calendar.current.startOfDay(for: result.timestamp)
        }
    }
    
    private func sectionTitle(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Hoje"
        } else if calendar.isDateInYesterday(date) {
            return "Ontem"
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear) {
            return "Esta Semana"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "d 'de' MMMM"
            formatter.locale = Locale(identifier: "pt_BR")
            return formatter.string(from: date)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
}

struct QuizHistoryRow: View {
    let result: QuizResultEntity
    let accentGold: Color
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: result.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(result.isCorrect ? .green : .red)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(result.question)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack {
                    Text(result.userAnswer)
                        .font(.system(size: 12))
                        .foregroundColor(result.isCorrect ? .green : .red)
                    
                    if !result.isCorrect {
                        Text("→")
                            .foregroundColor(.white.opacity(0.4))
                        Text(result.correctAnswer)
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
            
            // Time
            VStack(alignment: .trailing, spacing: 2) {
                Text(timeString(from: result.timestamp))
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.5))
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(accentGold.opacity(0.5))
            }
        }
        .padding(.vertical, 8)
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }
}

struct EmptyStateView: View {
    let filter: QuizHistoryView.FilterOption
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
            
            Text(emptyMessage)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var emptyMessage: String {
        switch filter {
        case .all:
            return "Nenhum quiz respondido ainda.\nResponda às notificações para ver seu histórico aqui!"
        case .correct:
            return "Nenhum acerto registrado ainda.\nContinue estudando!"
        case .incorrect:
            return "Nenhum erro registrado.\nVocê está indo muito bem! 🎉"
        }
    }
}

#Preview {
    NavigationStack {
        QuizHistoryView()
    }
    .modelContainer(for: QuizResultEntity.self, inMemory: true)
}
