//
//  NeuroProfile.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import Foundation

struct NeuroProfile: Codable {
    var baselineScores: [TestType: Double]
    var currentStreak: Int
    var bestStreak: Int
    var cognitiveFatigueTrend: [Double] // last 7 days
    var peakPerformanceTime: TimeOfDay?
    
    init(baselineScores: [TestType: Double] = [:], currentStreak: Int = 0, bestStreak: Int = 0, cognitiveFatigueTrend: [Double] = [], peakPerformanceTime: TimeOfDay? = nil) {
        self.baselineScores = baselineScores
        self.currentStreak = currentStreak
        self.bestStreak = bestStreak
        self.cognitiveFatigueTrend = cognitiveFatigueTrend
        self.peakPerformanceTime = peakPerformanceTime
    }
    
    var overallScore: Double {
        let scores = baselineScores.values
        guard !scores.isEmpty else { return 0 }
        return scores.reduce(0, +) / Double(scores.count)
    }
    
    var isInOptimalState: Bool {
        guard let lastFatigue = cognitiveFatigueTrend.last else { return true }
        return lastFatigue <= 60.0 // cognitive load <= 60%
    }
}

