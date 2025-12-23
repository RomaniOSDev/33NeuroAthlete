//
//  DefaultTests.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import Foundation

struct DefaultTests {
    static let tests: [CognitiveTest] = [
        CognitiveTest(
            name: "Lightning Reaction",
            type: .reaction,
            description: "Tap appearing dots as fast as possible",
            duration: 60,
            difficulty: .beginner,
            targetMetric: .reactionTime,
            instructions: ["Focus on center of screen", "React instantly", "Don't anticipate"]
        ),
        CognitiveTest(
            name: "Laser Focus",
            type: .attention,
            description: "Track moving target among distractions",
            duration: 90,
            difficulty: .intermediate,
            targetMetric: .accuracy,
            instructions: ["Don't lose target", "Ignore distracting objects", "Maintain concentration"]
        ),
        CognitiveTest(
            name: "Tactical Decision",
            type: .decision,
            description: "Choose optimal action in limited time",
            duration: 120,
            difficulty: .advanced,
            targetMetric: .processingSpeed,
            instructions: ["Analyze quickly", "Make confident decisions", "Consider consequences"]
        ),
        CognitiveTest(
            name: "Peripheral Vision",
            type: .vision,
            description: "React to objects at edges of vision field",
            duration: 75,
            difficulty: .intermediate,
            targetMetric: .reactionTime,
            instructions: ["Look straight ahead", "Notice side objects", "Don't move eyes"]
        )
    ]
}

