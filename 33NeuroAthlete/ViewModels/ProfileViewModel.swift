//
//  ProfileViewModel.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var profile: NeuroProfile = NeuroProfile(
        baselineScores: [
            .reaction: 300.0,
            .attention: 75.0,
            .decision: 70.0,
            .vision: 280.0
        ],
        currentStreak: 0,
        bestStreak: 0,
        cognitiveFatigueTrend: [45.0, 50.0, 42.0, 48.0, 40.0, 35.0, 38.0],
        peakPerformanceTime: .afternoon
    )
    @Published var testSessions: [TestSession] = []
    
    func updateBaselineScores(from sessions: [TestSession]) {
        var scores: [TestType: Double] = [:]
        
        for testType in TestType.allCases {
            let typeSessions = sessions.filter { session in
                // Need to match test type - simplified for now
                true
            }
            
            if testType == .reaction {
                let reactionTimes = typeSessions.compactMap { $0.results.reactionTime }
                if let avg = reactionTimes.average {
                    scores[testType] = avg
                }
            } else {
                let accuracies = typeSessions.compactMap { $0.results.accuracy }
                if let avg = accuracies.average {
                    scores[testType] = avg
                }
            }
        }
        
        profile.baselineScores = scores
    }
    
    func updateStreak() {
        guard !testSessions.isEmpty else {
            profile.currentStreak = 0
            return
        }
        
        // Group sessions by day
        let calendar = Calendar.current
        let sessionsByDay = Dictionary(grouping: testSessions) { session in
            calendar.startOfDay(for: session.startTime)
        }
        
        let sortedDays = sessionsByDay.keys.sorted(by: >)
        guard let mostRecentDay = sortedDays.first else {
            profile.currentStreak = 0
            return
        }
        
        let today = calendar.startOfDay(for: Date())
        
        // Check if most recent session was today or yesterday
        let daysSinceLastSession = calendar.dateComponents([.day], from: mostRecentDay, to: today).day ?? 0
        
        if daysSinceLastSession > 1 {
            // Streak broken
            profile.currentStreak = 0
        } else {
            // Calculate consecutive days with sessions
            var streak = 0
            var currentDay = today
            
            for _ in 0..<365 { // Max 365 days
                if sessionsByDay[currentDay] != nil {
                    streak += 1
                    if let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDay) {
                        currentDay = previousDay
                    } else {
                        break
                    }
                } else {
                    break
                }
            }
            
            profile.currentStreak = streak
            if streak > profile.bestStreak {
                profile.bestStreak = streak
            }
        }
    }
    
    func updateFatigueTrend(from sessions: [TestSession]) {
        let recentSessions = Array(sessions.suffix(7))
        let fatigueValues = recentSessions.map { $0.cognitiveLoad }
        profile.cognitiveFatigueTrend = fatigueValues
    }
    
    func determinePeakPerformanceTime(from sessions: [TestSession]) {
        var performanceByTime: [TimeOfDay: [Double]] = [:]
        
        for session in sessions {
            let performance = session.results.successRate
            if performanceByTime[session.conditions.timeOfDay] == nil {
                performanceByTime[session.conditions.timeOfDay] = []
            }
            performanceByTime[session.conditions.timeOfDay]?.append(performance)
        }
        
        var bestTime: TimeOfDay?
        var bestAvg: Double = 0
        
        for (time, values) in performanceByTime {
            let avg = values.reduce(0, +) / Double(values.count)
            if avg > bestAvg {
                bestAvg = avg
                bestTime = time
            }
        }
        
        profile.peakPerformanceTime = bestTime
    }
}

