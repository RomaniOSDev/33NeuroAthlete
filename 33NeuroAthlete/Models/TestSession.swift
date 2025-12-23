//
//  TestSession.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import Foundation

struct TestSession: Identifiable, Codable {
    let id: UUID
    var testId: UUID
    var startTime: Date
    var endTime: Date
    var results: TestResults
    var conditions: SessionConditions
    var notes: String?
    
    init(id: UUID = UUID(), testId: UUID, startTime: Date, endTime: Date, results: TestResults, conditions: SessionConditions, notes: String? = nil) {
        self.id = id
        self.testId = testId
        self.startTime = startTime
        self.endTime = endTime
        self.results = results
        self.conditions = conditions
        self.notes = notes
    }
    
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    var cognitiveLoad: Double {
        results.calculateCognitiveLoad()
    }
}

struct TestResults: Codable {
    var reactionTime: TimeInterval? // ms
    var accuracy: Double? // 0-100%
    var correctResponses: Int
    var incorrectResponses: Int
    var missedResponses: Int
    var averageProcessingTime: TimeInterval?
    var consistencyScore: Double? // 0-100%
    
    init(reactionTime: TimeInterval? = nil, accuracy: Double? = nil, correctResponses: Int = 0, incorrectResponses: Int = 0, missedResponses: Int = 0, averageProcessingTime: TimeInterval? = nil, consistencyScore: Double? = nil) {
        self.reactionTime = reactionTime
        self.accuracy = accuracy
        self.correctResponses = correctResponses
        self.incorrectResponses = incorrectResponses
        self.missedResponses = missedResponses
        self.averageProcessingTime = averageProcessingTime
        self.consistencyScore = consistencyScore
    }
    
    var totalResponses: Int {
        correctResponses + incorrectResponses + missedResponses
    }
    
    var successRate: Double {
        guard totalResponses > 0 else { return 0 }
        return Double(correctResponses) / Double(totalResponses) * 100
    }
    
    func calculateCognitiveLoad() -> Double {
        var load = 0.0
        
        if let reaction = reactionTime {
            // Faster reaction = less load (inverted)
            load += max(0, 500 - reaction) / 5 // normalization
        }
        
        if let accuracy = accuracy {
            load += accuracy // higher accuracy = more load (normal)
        }
        
        // Correction by number of responses
        load = min(load * (Double(totalResponses) / 50.0), 100.0)
        
        return load
    }
}

struct SessionConditions: Codable {
    var timeOfDay: TimeOfDay
    var fatigueLevel: Int // 1-10
    var preWorkout: Bool
    var postWorkout: Bool
    var hoursSinceSleep: Int?
    
    init(timeOfDay: TimeOfDay = .afternoon, fatigueLevel: Int = 5, preWorkout: Bool = false, postWorkout: Bool = false, hoursSinceSleep: Int? = nil) {
        self.timeOfDay = timeOfDay
        self.fatigueLevel = fatigueLevel
        self.preWorkout = preWorkout
        self.postWorkout = postWorkout
        self.hoursSinceSleep = hoursSinceSleep
    }
    
    var idealForTraining: Bool {
        fatigueLevel <= 5 && (hoursSinceSleep ?? 24) <= 16
    }
}

enum TimeOfDay: String, CaseIterable, Codable {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case night = "Night"
}

