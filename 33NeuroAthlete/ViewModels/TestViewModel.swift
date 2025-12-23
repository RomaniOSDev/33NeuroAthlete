//
//  TestViewModel.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import Foundation
import SwiftUI
import Combine

class TestViewModel: ObservableObject {
    @Published var availableTests: [CognitiveTest] = DefaultTests.tests
    @Published var currentTest: CognitiveTest?
    @Published var testSessions: [TestSession] = []
    @Published var isTestRunning = false
    @Published var currentSession: TestSession?
    @Published var testResults: TestResults = TestResults()
    
    // Reaction test state
    @Published var reactionTargets: [ReactionTarget] = []
    @Published var currentReactionTime: TimeInterval?
    @Published var reactionStartTime: Date?
    
    // Attention test state
    @Published var attentionTargets: [AttentionTarget] = []
    @Published var selectedTargetId: UUID?
    
    // Decision test state
    @Published var decisionScenarios: [DecisionScenario] = []
    @Published var currentScenario: DecisionScenario?
    
    // Vision test state
    @Published var visionTargets: [VisionTarget] = []
    
    func startTest(_ test: CognitiveTest) {
        currentTest = test
        testResults = TestResults()
        isTestRunning = true
        
        let conditions = SessionConditions(
            timeOfDay: getCurrentTimeOfDay(),
            fatigueLevel: 5,
            preWorkout: false,
            postWorkout: false
        )
        
        currentSession = TestSession(
            testId: test.id,
            startTime: Date(),
            endTime: Date(),
            results: testResults,
            conditions: conditions
        )
        
        switch test.type {
        case .reaction:
            setupReactionTest()
        case .attention:
            setupAttentionTest()
        case .decision:
            setupDecisionTest()
        case .vision:
            setupVisionTest()
        }
    }
    
    func endTest() {
        guard var session = currentSession, let test = currentTest else { return }
        
        session.endTime = Date()
        session.results = testResults
        
        // Calculate final metrics
        calculateFinalMetrics()
        
        testSessions.append(session)
        isTestRunning = false
        currentSession = nil
        currentTest = nil
    }
    
    private func calculateFinalMetrics() {
        guard let session = currentSession else { return }
        
        let total = testResults.totalResponses
        if total > 0 {
            testResults.accuracy = testResults.successRate
        }
        
        // Calculate consistency if we have multiple reaction times
        if !reactionTargets.isEmpty {
            let times = reactionTargets.compactMap { $0.reactionTime }
            if times.count > 1 {
                let avg = times.reduce(0, +) / Double(times.count)
                let variance = times.map { pow($0 - avg, 2) }.reduce(0, +) / Double(times.count)
                let stdDev = sqrt(variance)
                testResults.consistencyScore = max(0, 100 - (stdDev / avg * 100))
            }
        }
    }
    
    // MARK: - Reaction Test
    private func setupReactionTest() {
        reactionTargets = []
        generateReactionTarget()
    }
    
    func generateReactionTarget() {
        let target = ReactionTarget(
            id: UUID(),
            position: randomPosition(),
            color: Bool.random() ? Color(hex: "006872") : Color(hex: "FF0055"),
            appearedAt: Date()
        )
        reactionTargets.append(target)
        reactionStartTime = Date()
    }
    
    func handleReactionTap(at location: CGPoint, targetId: UUID) {
        guard let targetIndex = reactionTargets.firstIndex(where: { $0.id == targetId }),
              let startTime = reactionStartTime else { return }
        
        let reactionTime = Date().timeIntervalSince(startTime) * 1000 // ms
        
        // Update target with reaction time
        var updatedTarget = reactionTargets[targetIndex]
        updatedTarget.reactionTime = reactionTime
        reactionTargets[targetIndex] = updatedTarget
        
        testResults.correctResponses += 1
        if let current = testResults.reactionTime {
            testResults.reactionTime = (current + reactionTime) / 2
        } else {
            testResults.reactionTime = reactionTime
        }
        
        // Remove tapped target
        reactionTargets.remove(at: targetIndex)
        
        // Generate next target after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.isTestRunning {
                self.generateReactionTarget()
            }
        }
    }
    
    // MARK: - Attention Test
    private func setupAttentionTest() {
        attentionTargets = []
        for _ in 0..<5 {
            let target = AttentionTarget(
                id: UUID(),
                position: randomPosition(),
                isTarget: false,
                velocity: CGSize(width: Double.random(in: -50...50), height: Double.random(in: -50...50))
            )
            attentionTargets.append(target)
        }
        // Mark one as target
        if let first = attentionTargets.first {
            selectedTargetId = first.id
            if let index = attentionTargets.firstIndex(where: { $0.id == first.id }) {
                var updatedTarget = attentionTargets[index]
                updatedTarget.isTarget = true
                attentionTargets[index] = updatedTarget
            }
        }
    }
    
    func updateAttentionTargetPositions(screenWidth: CGFloat, screenHeight: CGFloat) {
        for index in attentionTargets.indices {
            var target = attentionTargets[index]
            
            // Update position based on velocity
            target.position.x += target.velocity.width * 0.016
            target.position.y += target.velocity.height * 0.016
            
            // Bounce off edges
            if target.position.x < 50 || target.position.x > screenWidth - 50 {
                target.velocity.width *= -1
            }
            if target.position.y < 100 || target.position.y > screenHeight - 100 {
                target.velocity.height *= -1
            }
            
            attentionTargets[index] = target
        }
    }
    
    // MARK: - Decision Test
    private func setupDecisionTest() {
        decisionScenarios = []
        generateDecisionScenario()
    }
    
    func generateDecisionScenario() {
        let scenarios = [
            DecisionScenario(id: UUID(), question: "Pass or Shoot?", options: ["Pass", "Shoot"], correctAnswer: 0, timeLimit: 2.0),
            DecisionScenario(id: UUID(), question: "Defend or Attack?", options: ["Defend", "Attack"], correctAnswer: 1, timeLimit: 1.5),
            DecisionScenario(id: UUID(), question: "Left or Right?", options: ["Left", "Right"], correctAnswer: Int.random(in: 0...1), timeLimit: 1.0)
        ]
        currentScenario = scenarios.randomElement()
    }
    
    // MARK: - Vision Test
    private func setupVisionTest() {
        visionTargets = []
        generateVisionTarget()
    }
    
    func generateVisionTarget() {
        let edge = Int.random(in: 0..<4) // 0=top, 1=right, 2=bottom, 3=left
        let position = positionAtEdge(edge)
        
        let target = VisionTarget(
            id: UUID(),
            position: position,
            appearedAt: Date()
        )
        visionTargets.append(target)
    }
    
    // MARK: - Helpers
    private func randomPosition() -> CGPoint {
        CGPoint(
            x: Double.random(in: 100...700),
            y: Double.random(in: 200...1000)
        )
    }
    
    private func positionAtEdge(_ edge: Int) -> CGPoint {
        switch edge {
        case 0: return CGPoint(x: Double.random(in: 100...700), y: 100) // top
        case 1: return CGPoint(x: 700, y: Double.random(in: 200...1000)) // right
        case 2: return CGPoint(x: Double.random(in: 100...700), y: 1000) // bottom
        case 3: return CGPoint(x: 100, y: Double.random(in: 200...1000)) // left
        default: return randomPosition()
        }
    }
    
    private func getCurrentTimeOfDay() -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return .morning
        case 12..<17: return .afternoon
        case 17..<22: return .evening
        default: return .night
        }
    }
}

// MARK: - Supporting Types
struct ReactionTarget: Identifiable {
    let id: UUID
    let position: CGPoint
    let color: Color
    let appearedAt: Date
    var reactionTime: TimeInterval?
}

struct AttentionTarget: Identifiable {
    let id: UUID
    var position: CGPoint
    var isTarget: Bool
    var velocity: CGSize
}

struct DecisionScenario: Identifiable {
    let id: UUID
    let question: String
    let options: [String]
    let correctAnswer: Int
    let timeLimit: TimeInterval
}

struct VisionTarget: Identifiable {
    let id: UUID
    let position: CGPoint
    let appearedAt: Date
}

