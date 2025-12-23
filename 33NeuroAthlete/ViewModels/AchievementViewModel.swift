//
//  AchievementViewModel.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import Foundation
import Combine

class AchievementViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var unlockedCount: Int = 0
    
    init() {
        loadDefaultAchievements()
    }
    
    private func loadDefaultAchievements() {
        achievements = [
            // Streak Achievements
            Achievement(
                title: "First Steps",
                description: "Complete your first test",
                iconName: "star.fill",
                category: .dedication,
                requirement: 1
            ),
            Achievement(
                title: "Week Warrior",
                description: "Maintain a 7-day streak",
                iconName: "flame.fill",
                category: .streak,
                requirement: 7
            ),
            Achievement(
                title: "Month Master",
                description: "Maintain a 30-day streak",
                iconName: "crown.fill",
                category: .streak,
                requirement: 30
            ),
            
            // Performance Achievements
            Achievement(
                title: "Lightning Fast",
                description: "Achieve reaction time under 200ms",
                iconName: "bolt.fill",
                category: .performance,
                requirement: 200
            ),
            Achievement(
                title: "Perfect Accuracy",
                description: "Score 100% accuracy in any test",
                iconName: "target",
                category: .performance,
                requirement: 100
            ),
            Achievement(
                title: "Elite Performer",
                description: "Reach overall score of 90+",
                iconName: "trophy.fill",
                category: .performance,
                requirement: 90
            ),
            
            // Consistency Achievements
            Achievement(
                title: "Steady Hand",
                description: "Maintain 80%+ consistency for 10 tests",
                iconName: "hand.raised.fill",
                category: .consistency,
                requirement: 10
            ),
            Achievement(
                title: "Unstoppable",
                description: "Complete 100 tests",
                iconName: "infinity",
                category: .dedication,
                requirement: 100
            ),
            
            // Mastery Achievements
            Achievement(
                title: "Reaction Master",
                description: "Master all reaction tests",
                iconName: "eye.fill",
                category: .mastery,
                requirement: 1
            ),
            Achievement(
                title: "Focus Master",
                description: "Master all attention tests",
                iconName: "brain.head.profile",
                category: .mastery,
                requirement: 1
            ),
            Achievement(
                title: "Decision Master",
                description: "Master all decision tests",
                iconName: "checkmark.circle.fill",
                category: .mastery,
                requirement: 1
            ),
            Achievement(
                title: "Vision Master",
                description: "Master all vision tests",
                iconName: "viewfinder",
                category: .mastery,
                requirement: 1
            )
        ]
    }
    
    func updateAchievements(
        streak: Int,
        totalTests: Int,
        bestReactionTime: TimeInterval?,
        bestAccuracy: Double?,
        overallScore: Double,
        consistencyScore: Double?
    ) {
        for index in achievements.indices {
            var achievement = achievements[index]
            
            switch achievement.category {
            case .streak:
                if achievement.title.contains("Week") {
                    achievement.progress = min(100, (Double(streak) / achievement.requirement) * 100)
                    if streak >= Int(achievement.requirement) && !achievement.isUnlocked {
                        unlockAchievement(at: index)
                    }
                } else if achievement.title.contains("Month") {
                    achievement.progress = min(100, (Double(streak) / achievement.requirement) * 100)
                    if streak >= Int(achievement.requirement) && !achievement.isUnlocked {
                        unlockAchievement(at: index)
                    }
                }
                
            case .performance:
                if achievement.title.contains("Lightning") {
                    if let reactionTime = bestReactionTime {
                        achievement.progress = min(100, (achievement.requirement / reactionTime) * 100)
                        if reactionTime <= achievement.requirement && !achievement.isUnlocked {
                            unlockAchievement(at: index)
                        }
                    }
                } else if achievement.title.contains("Perfect") {
                    if let accuracy = bestAccuracy {
                        achievement.progress = accuracy
                        if accuracy >= achievement.requirement && !achievement.isUnlocked {
                            unlockAchievement(at: index)
                        }
                    }
                } else if achievement.title.contains("Elite") {
                    achievement.progress = overallScore
                    if overallScore >= achievement.requirement && !achievement.isUnlocked {
                        unlockAchievement(at: index)
                    }
                }
                
            case .consistency:
                if achievement.title.contains("Steady") {
                    if let consistency = consistencyScore {
                        achievement.progress = consistency
                        if consistency >= achievement.requirement && !achievement.isUnlocked {
                            unlockAchievement(at: index)
                        }
                    }
                }
                
            case .dedication:
                if achievement.title.contains("First") {
                    achievement.progress = totalTests >= 1 ? 100 : 0
                    if totalTests >= 1 && !achievement.isUnlocked {
                        unlockAchievement(at: index)
                    }
                } else if achievement.title.contains("Unstoppable") {
                    achievement.progress = min(100, (Double(totalTests) / achievement.requirement) * 100)
                    if totalTests >= Int(achievement.requirement) && !achievement.isUnlocked {
                        unlockAchievement(at: index)
                    }
                }
                
            case .mastery:
                // Mastery achievements would need more complex logic
                break
            }
            
            achievements[index] = achievement
        }
        
        unlockedCount = achievements.filter { $0.isUnlocked }.count
    }
    
    private func unlockAchievement(at index: Int) {
        achievements[index].isUnlocked = true
        achievements[index].unlockedDate = Date()
    }
}

