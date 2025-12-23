//
//  TrainingProgram.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import Foundation

struct TrainingProgram: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var focusArea: TestType
    var durationDays: Int
    var dailySessions: Int
    var tests: [UUID] // test IDs
    var targetImprovement: Double // % improvement
    var isActive: Bool
    var startDate: Date?
    var completionRate: Double // 0-100%
    
    init(id: UUID = UUID(), name: String, description: String, focusArea: TestType, durationDays: Int, dailySessions: Int, tests: [UUID], targetImprovement: Double, isActive: Bool = false, startDate: Date? = nil, completionRate: Double = 0.0) {
        self.id = id
        self.name = name
        self.description = description
        self.focusArea = focusArea
        self.durationDays = durationDays
        self.dailySessions = dailySessions
        self.tests = tests
        self.targetImprovement = targetImprovement
        self.isActive = isActive
        self.startDate = startDate
        self.completionRate = completionRate
    }
}

