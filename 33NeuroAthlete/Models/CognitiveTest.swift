//
//  CognitiveTest.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI

struct CognitiveTest: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: TestType
    var description: String
    var duration: TimeInterval // seconds
    var difficulty: DifficultyLevel
    var targetMetric: CognitiveMetric
    var instructions: [String]
    
    init(id: UUID = UUID(), name: String, type: TestType, description: String, duration: TimeInterval, difficulty: DifficultyLevel, targetMetric: CognitiveMetric, instructions: [String]) {
        self.id = id
        self.name = name
        self.type = type
        self.description = description
        self.duration = duration
        self.difficulty = difficulty
        self.targetMetric = targetMetric
        self.instructions = instructions
    }
    
    var accentColor: Color {
        switch type {
        case .reaction: return Color(hex: "FF0055")
        case .attention: return Color(hex: "006872")
        case .decision: return Color(hex: "00F9FF")
        case .vision: return Color(hex: "6C5CE7")
        }
    }
}

enum TestType: String, CaseIterable, Codable {
    case reaction = "Reaction"
    case attention = "Attention"
    case decision = "Decision Making"
    case vision = "Vision Skills"
}

enum DifficultyLevel: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case elite = "Elite"
    
    var color: Color {
        switch self {
        case .beginner: return Color(hex: "00FF88")
        case .intermediate: return Color(hex: "00F9FF")
        case .advanced: return Color(hex: "006872")
        case .elite: return Color(hex: "FF0055")
        }
    }
}

enum CognitiveMetric: String, CaseIterable, Codable {
    case reactionTime = "Reaction Time"
    case accuracy = "Accuracy"
    case consistency = "Consistency"
    case processingSpeed = "Processing Speed"
    case errorRate = "Error Rate"
}

