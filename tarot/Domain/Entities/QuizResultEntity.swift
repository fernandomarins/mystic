//
//  QuizResultEntity.swift
//  tarot
//
//  Created by Antigravity on 30/01/26.
//

import SwiftData
import Foundation

@Model
final class QuizResultEntity {
    var id: UUID
    var question: String
    var correctAnswer: String
    var userAnswer: String
    var isCorrect: Bool
    var figureId: Int
    var timestamp: Date
    
    init(question: String, correctAnswer: String, userAnswer: String, isCorrect: Bool, figureId: Int, timestamp: Date) {
        self.id = UUID()
        self.question = question
        self.correctAnswer = correctAnswer
        self.userAnswer = userAnswer
        self.isCorrect = isCorrect
        self.figureId = figureId
        self.timestamp = timestamp
    }
    
    // Convenience initializer from QuizResult
    convenience init(from result: QuizResult) {
        self.init(
            question: result.question,
            correctAnswer: result.correctAnswer,
            userAnswer: result.userAnswer,
            isCorrect: result.isCorrect,
            figureId: result.figureId,
            timestamp: result.timestamp
        )
    }
}
