//
//  DifficultyProgression.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import Foundation

struct DifficultyProgression {
    static func adjustDifficulty(currentResults: TestResults, currentDifficulty: DifficultyLevel) -> DifficultyLevel {
        let successRate = currentResults.successRate
        
        switch currentDifficulty {
        case .beginner:
            if successRate >= 85 {
                return .intermediate
            } else if successRate <= 60 {
                return .beginner // stay at same level
            }
        case .intermediate:
            if successRate >= 80 {
                return .advanced
            } else if successRate <= 65 {
                return .beginner
            }
        case .advanced:
            if successRate >= 75 {
                return .elite
            } else if successRate <= 60 {
                return .intermediate
            }
        case .elite:
            if successRate <= 55 {
                return .advanced
            }
        }
        
        return currentDifficulty
    }
    
    static func parametersForDifficulty(_ difficulty: DifficultyLevel, testType: TestType) -> (timeLimit: TimeInterval, targets: Int, distractions: Int) {
        switch (difficulty, testType) {
        case (.beginner, .reaction):
            return (2.0, 1, 0)
        case (.intermediate, .reaction):
            return (1.5, 1, 1)
        case (.advanced, .reaction):
            return (1.0, 2, 2)
        case (.elite, .reaction):
            return (0.7, 3, 3)
        case (.beginner, .attention):
            return (3.0, 1, 2)
        case (.intermediate, .attention):
            return (2.0, 2, 3)
        case (.advanced, .attention):
            return (1.5, 3, 4)
        case (.elite, .attention):
            return (1.0, 4, 5)
        default:
            return (2.0, 1, 1)
        }
    }
}

