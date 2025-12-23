//
//  FatigueViewModel.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import Foundation
import Combine

class FatigueViewModel: ObservableObject {
    @Published var currentAssessment: CognitiveFatigueAssessment?
    @Published var subjectiveScore: Int = 5
    @Published var assessments: [CognitiveFatigueAssessment] = []
    
    func assessFatigue(sessions: [TestSession], profile: NeuroProfile) {
        let assessment = CognitiveFatigueAnalyzer.assessFatigue(
            sessions: sessions,
            profile: profile,
            subjectiveScore: subjectiveScore
        )
        
        currentAssessment = assessment
        assessments.append(assessment)
    }
    
    func updateSubjectiveScore(_ score: Int) {
        subjectiveScore = max(1, min(10, score))
    }
    
    func getRecommendations() -> [String] {
        return currentAssessment?.recommendations ?? []
    }
    
    func getRecoveryTimeString() -> String {
        guard let recoveryTime = currentAssessment?.recoveryTimeEstimate else {
            return "No recovery needed"
        }
        
        if recoveryTime == 0 {
            return "No recovery needed"
        }
        
        let minutes = Int(recoveryTime / 60)
        if minutes < 60 {
            return "\(minutes) minutes"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return "\(hours)h \(remainingMinutes)m"
        }
    }
}

