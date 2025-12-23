//
//  CognitiveFatigueAssessment.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import Foundation

struct CognitiveFatigueAssessment: Identifiable, Codable {
    let id: UUID
    var date: Date
    var subjectiveScore: Int // 1-10
    var objectiveScore: Double // from tests
    var recommendations: [String]
    var recoveryTimeEstimate: TimeInterval // minutes
    
    init(id: UUID = UUID(), date: Date = Date(), subjectiveScore: Int, objectiveScore: Double, recommendations: [String], recoveryTimeEstimate: TimeInterval) {
        self.id = id
        self.date = date
        self.subjectiveScore = subjectiveScore
        self.objectiveScore = objectiveScore
        self.recommendations = recommendations
        self.recoveryTimeEstimate = recoveryTimeEstimate
    }
}

