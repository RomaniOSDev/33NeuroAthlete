//
//  CognitiveFatigueAnalyzer.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import Foundation

struct CognitiveFatigueAnalyzer {
    static func assessFatigue(sessions: [TestSession], profile: NeuroProfile, subjectiveScore: Int = 5) -> CognitiveFatigueAssessment {
        let recentSessions = Array(sessions.suffix(5)) // last 5 tests
        let now = Date()
        
        // Objective assessment (from test results)
        let reactionTimes = recentSessions.compactMap { $0.results.reactionTime }
        let averageReaction = reactionTimes.isEmpty ? 0 : reactionTimes.reduce(0, +) / Double(reactionTimes.count)
        
        let baselineReaction = profile.baselineScores[.reaction] ?? 300.0
        let reactionIncrease = baselineReaction > 0 ? ((averageReaction - baselineReaction) / baselineReaction) * 100 : 0
        
        let objectiveScore = calculateObjectiveScore(
            reactionIncrease: reactionIncrease,
            accuracy: recentSessions.compactMap { $0.results.accuracy }.average,
            consistency: recentSessions.compactMap { $0.results.consistencyScore }.average
        )
        
        // Recommendations
        var recommendations: [String] = []
        
        if reactionIncrease > 20 {
            recommendations.append("Reaction time slowed by \(Int(reactionIncrease))%. Rest before important game.")
        }
        
        if objectiveScore > 70 {
            recommendations.append("High cognitive load. Recommend light training instead of intense.")
        } else if objectiveScore < 30 {
            recommendations.append("Optimal state! Perfect time for complex training.")
        }
        
        // Recovery time estimate
        let recoveryTime = estimateRecoveryTime(fatigueScore: objectiveScore)
        
        return CognitiveFatigueAssessment(
            date: now,
            subjectiveScore: subjectiveScore,
            objectiveScore: objectiveScore,
            recommendations: recommendations,
            recoveryTimeEstimate: recoveryTime
        )
    }
    
    private static func calculateObjectiveScore(reactionIncrease: Double, accuracy: Double?, consistency: Double?) -> Double {
        var score = 0.0
        
        // Contribution of reaction slowdown (0-50 points)
        if reactionIncrease <= 10 {
            score += 50
        } else if reactionIncrease <= 25 {
            score += 30
        } else if reactionIncrease <= 50 {
            score += 10
        }
        
        // Contribution of accuracy (0-30 points)
        if let accuracy = accuracy {
            if accuracy >= 90 {
                score += 30
            } else if accuracy >= 80 {
                score += 20
            } else if accuracy >= 70 {
                score += 10
            }
        }
        
        // Contribution of consistency (0-20 points)
        if let consistency = consistency {
            score += consistency * 0.2
        }
        
        return min(score, 100.0)
    }
    
    private static func estimateRecoveryTime(fatigueScore: Double) -> TimeInterval {
        switch fatigueScore {
        case 0..<30:
            return 0 // no recovery needed
        case 30..<50:
            return 15 * 60 // 15 minutes
        case 50..<70:
            return 30 * 60 // 30 minutes
        case 70..<85:
            return 60 * 60 // 1 hour
        default:
            return 90 * 60 // 1.5 hours
        }
    }
}

