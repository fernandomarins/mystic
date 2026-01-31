//
//  QuizNotificationManager.swift
//  tarot
//
//  Created by Antigravity on 28/01/26.
//

import Foundation
import UserNotifications

struct QuizResult: Codable {
    let question: String
    let correctAnswer: String
    let userAnswer: String
    let isCorrect: Bool
    let figureId: Int
    let timestamp: Date
}

class QuizNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = QuizNotificationManager()
    
    private let categoryIdentifier = "GEOMANCIA_QUIZ_CATEGORY"
    private var figures: [GeomanciaMeaning] = []
    
    var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "GeomanciaQuizNotificationsEnabled") }
        set { 
            UserDefaults.standard.set(newValue, forKey: "GeomanciaQuizNotificationsEnabled")
            if newValue {
                schedulePeriodicQuiz()
            } else {
                cancelAllNotifications()
            }
        }
    }
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        loadData()
        registerCategory()
    }
    
    private func loadData() {
        guard let url = Bundle.main.url(forResource: "geomancia", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(GeomanciaResponse.self, from: data)
            self.figures = response.forms
        } catch {
            print("Error loading geomancia data for notifications: \(error)")
        }
    }
    
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
                // Set enabled by default on first success if not set
                if UserDefaults.standard.object(forKey: "GeomanciaQuizNotificationsEnabled") == nil {
                    self.isEnabled = true
                }
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    private func registerCategory() {
        let actions = (1...4).map { i in
            UNNotificationAction(identifier: "OPTION_\(i)", title: "Opção \(i)", options: .foreground)
        }
        
        let category = UNNotificationCategory(
            identifier: categoryIdentifier,
            actions: actions,
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func schedulePeriodicQuiz() {
        guard isEnabled else { return }
        
        // Cancel existing to avoid duplicates and start fresh
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Slots: 09:00, 11:00, 13:00, 15:00, 17:00, 19:00, 21:00 (7 per day)
        let hours = [9, 11, 13, 15, 17, 19, 21]
        
        // iOS limit is 64. 60 notifications = ~8.5 days
        var count = 0
        for day in 0...8 {
            for hour in hours {
                if count >= 60 { break }
                scheduleNotification(dayOffset: day, hour: hour, minute: 0, index: count)
                count += 1
            }
        }
    }
    
    private func scheduleNotification(dayOffset: Int, hour: Int, minute: Int, index: Int) {
        guard figures.count >= 4 else { return }
        
        let correctFigure = figures.randomElement()!
        var options = figures.filter { $0.id != correctFigure.id }.shuffled().prefix(3)
        options.append(correctFigure)
        let shuffledOptions = options.shuffled()
        
        let content = UNMutableNotificationContent()
        content.title = "Quiz de Geomancia 🔮"
        
        let type = Int.random(in: 0...2)
        var body = ""
        var correctAnswerIndex = 0
        
        switch type {
        case 0:
            body = "Qual o nome da figura com o padrão \(patternToString(correctFigure.pattern))?"
            for (i, opt) in shuffledOptions.enumerated() {
                body += "\n\(i + 1). \(opt.name)"
                if opt.id == correctFigure.id { correctAnswerIndex = i + 1 }
            }
        case 1:
            body = "Qual a palavra-chave da figura \(correctFigure.name)?"
            for (i, opt) in shuffledOptions.enumerated() {
                body += "\n\(i + 1). \(opt.keyword ?? "???")"
                if opt.id == correctFigure.id { correctAnswerIndex = i + 1 }
            }
        default:
            body = "Qual o planeta associado à figura \(correctFigure.name)?"
            for (i, opt) in shuffledOptions.enumerated() {
                body += "\n\(i + 1). \(opt.planet ?? "Nenhum")"
                if opt.id == correctFigure.id { correctAnswerIndex = i + 1 }
            }
        }
        
        content.body = body
        content.categoryIdentifier = categoryIdentifier
        content.userInfo = ["CORRECT_ANSWER": "OPTION_\(correctAnswerIndex)", "FIGURE_ID": correctFigure.id]
        content.sound = .default
        
        // Calculation of target date
        let calendar = Calendar.current
        var targetDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
        targetDate = calendar.date(byAdding: .day, value: dayOffset, to: targetDate) ?? targetDate
        
        // If the calculated time is in the past (today), skip or move to tomorrow
        if targetDate < Date() { return }
        
        let triggerDate = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "GEOMANCIA_QUIZ_\(index)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func patternToString(_ pattern: [Int]) -> String {
        return pattern.map { $0 == 1 ? "·" : "··" }.joined(separator: " / ")
    }
    
    // Handle notification when app is in FOREGROUND
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    // Handle notification when user TAPS on it
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("🔔 Notification tapped! ActionID: \(response.actionIdentifier)")
        
        let userInfo = response.notification.request.content.userInfo
        let correctIdentifier = userInfo["CORRECT_ANSWER"] as? String
        let figureId = userInfo["FIGURE_ID"] as? Int ?? 0
        let questionBody = response.notification.request.content.body
        
        print("📝 Question body: \(questionBody)")
        print("✅ Correct answer: \(correctIdentifier ?? "nil")")
        
        if response.actionIdentifier.hasPrefix("OPTION_") {
            let isCorrect = response.actionIdentifier == correctIdentifier
            
            print(isCorrect ? "✅ CORRECT ANSWER!" : "❌ INCORRECT ANSWER")
            
            // Extract user answer and correct answer from the question
            let userAnswerNumber = response.actionIdentifier.replacingOccurrences(of: "OPTION_", with: "")
            let correctAnswerNumber = correctIdentifier?.replacingOccurrences(of: "OPTION_", with: "") ?? "0"
            
            // Parse the body to get answers
            let lines = questionBody.components(separatedBy: "\n")
            let userAnswerText = lines.first(where: { $0.hasPrefix("\(userAnswerNumber).") })?.replacingOccurrences(of: "\(userAnswerNumber). ", with: "") ?? "?"
            let correctAnswerText = lines.first(where: { $0.hasPrefix("\(correctAnswerNumber).") })?.replacingOccurrences(of: "\(correctAnswerNumber). ", with: "") ?? "?"
            
            // Get the question (first line)
            let question = lines.first ?? "Quiz de Geomancia"
            
            print("🙋 User answered: \(userAnswerText)")
            print("🎯 Correct was: \(correctAnswerText)")
            
            // Create and save result
            let result = QuizResult(
                question: question,
                correctAnswer: correctAnswerText,
                userAnswer: userAnswerText,
                isCorrect: isCorrect,
                figureId: figureId,
                timestamp: Date()
            )
            saveLastResult(result)
            
            print("💾 Result saved to UserDefaults")
            
            // Post notification to trigger UI update
            DispatchQueue.main.async {
                print("📢 Posting NotificationCenter event...")
                NotificationCenter.default.post(name: NSNotification.Name("ShowQuizResult"), object: nil)
                print("📢 Event posted!")
            }
            
            // Refill schedule to keep it "forever"
            if isEnabled {
                schedulePeriodicQuiz()
            }
        }
        
        completionHandler()
    }
    
    private func saveLastResult(_ result: QuizResult) {
        if let encoded = try? JSONEncoder().encode(result) {
            UserDefaults.standard.set(encoded, forKey: "LastQuizResult")
        }
    }
    
    func getLastResult() -> QuizResult? {
        guard let data = UserDefaults.standard.data(forKey: "LastQuizResult") else { return nil }
        return try? JSONDecoder().decode(QuizResult.self, from: data)
    }
    
    func clearLastResult() {
        UserDefaults.standard.removeObject(forKey: "LastQuizResult")
    }
}

extension String {
    func startsWith(_ prefix: String) -> Bool {
        return self.hasPrefix(prefix)
    }
}
