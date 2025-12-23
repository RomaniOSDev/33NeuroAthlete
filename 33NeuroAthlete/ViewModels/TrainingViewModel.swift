//
//  TrainingViewModel.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import Foundation
import Combine

class TrainingViewModel: ObservableObject {
    @Published var programs: [TrainingProgram] = []
    @Published var activeProgram: TrainingProgram?
    @Published var completedSessionsToday: Int = 0
    
    init() {
        loadDefaultPrograms()
    }
    
    private func loadDefaultPrograms() {
        programs = [
            TrainingProgram(
                name: "Reaction Master",
                description: "7-day intensive reaction training",
                focusArea: .reaction,
                durationDays: 7,
                dailySessions: 3,
                tests: DefaultTests.tests.filter { $0.type == .reaction }.map { $0.id },
                targetImprovement: 25.0
            ),
            TrainingProgram(
                name: "Focus Builder",
                description: "14-day attention enhancement program",
                focusArea: .attention,
                durationDays: 14,
                dailySessions: 2,
                tests: DefaultTests.tests.filter { $0.type == .attention }.map { $0.id },
                targetImprovement: 30.0
            )
        ]
    }
    
    func activateProgram(_ program: TrainingProgram) {
        activeProgram = program
        if let index = programs.firstIndex(where: { $0.id == program.id }) {
            programs[index].isActive = true
            programs[index].startDate = Date()
        }
    }
    
    func deactivateProgram(_ program: TrainingProgram) {
        if let index = programs.firstIndex(where: { $0.id == program.id }) {
            programs[index].isActive = false
        }
        if activeProgram?.id == program.id {
            activeProgram = nil
        }
    }
    
    func recordSession() {
        completedSessionsToday += 1
    }
    
    func updateProgramProgress(sessions: [TestSession]) {
        for index in programs.indices {
            guard programs[index].isActive,
                  let startDate = programs[index].startDate else { continue }
            
            let program = programs[index]
            let calendar = Calendar.current
            let daysSinceStart = calendar.dateComponents([.day], from: startDate, to: Date()).day ?? 0
            
            // Count sessions for this program
            let programSessions = sessions.filter { session in
                program.tests.contains(session.testId) &&
                session.startTime >= startDate
            }
            
            let expectedSessions = min(daysSinceStart + 1, program.durationDays) * program.dailySessions
            let completionRate = expectedSessions > 0 ? 
                (Double(programSessions.count) / Double(expectedSessions)) * 100 : 0
            
            programs[index].completionRate = min(100, max(0, completionRate))
        }
    }
}

