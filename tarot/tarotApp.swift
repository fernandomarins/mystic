//
//  tarotApp.swift
//  tarot
//
//  Created by Fernando Marins on 18/09/24.
//

import SwiftUI
import SwiftData

@main
struct tarotApp: App {
    @State private var showQuizResult: Bool = false
    @State private var quizResult: QuizResult? = nil
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        QuizNotificationManager.shared.requestPermissions()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    syncPendingQuizResults()
                }
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    if newPhase == .active {
                        syncPendingQuizResults()
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ShowQuizResult"))) { notification in
                    print("🎬 tarotApp received ShowQuizResult notification!")
                    // Small delay to ensure data is saved
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        quizResult = QuizNotificationManager.shared.getLastResult()
                        print("📦 Retrieved result: \(quizResult != nil ? "SUCCESS" : "NIL")")
                        if let result = quizResult {
                            print("   Question: \(result.question)")
                            print("   Correct: \(result.isCorrect)")
                        }
                        showQuizResult = quizResult != nil
                        print("🎭 Setting showQuizResult to: \(showQuizResult)")
                    }
                }
                .sheet(isPresented: $showQuizResult) {
                    if let result = quizResult {
                        QuizNotificationResultView(result: result)
                            .onDisappear {
                                print("👋 Quiz result sheet dismissed")
                                QuizNotificationManager.shared.clearLastResult()
                                quizResult = nil
                            }
                    }
                }
        }
        .modelContainer(for: [CardEntity.self, HerbEntity.self, RuneEntity.self, DaemonEntity.self, PlanetEntity.self, QuizResultEntity.self])
    }
    
    @MainActor
    private func syncPendingQuizResults() {
        guard let container = try? ModelContainer(for: QuizResultEntity.self) else {
            print("❌ Failed to get model container")
            return
        }
        
        let context = ModelContext(container)
        
        // Get all pending results from UserDefaults
        if let result = QuizNotificationManager.shared.getLastResult() {
            print("🔄 Syncing pending quiz result to SwiftData...")
            
            // Check if this result already exists (by timestamp)
            let descriptor = FetchDescriptor<QuizResultEntity>(
                predicate: #Predicate { entity in
                    entity.timestamp == result.timestamp
                }
            )
            
            if let existing = try? context.fetch(descriptor), existing.isEmpty {
                let entity = QuizResultEntity(from: result)
                context.insert(entity)
                try? context.save()
                print("✅ Quiz result synced to SwiftData")
            } else {
                print("ℹ️ Quiz result already exists in SwiftData")
            }
        }
    }
}
