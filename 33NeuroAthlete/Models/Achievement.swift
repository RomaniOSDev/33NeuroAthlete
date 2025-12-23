//
//  Achievement.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI

struct Achievement: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var iconName: String
    var category: AchievementCategory
    var requirement: Double // значение для разблокировки
    var isUnlocked: Bool
    var unlockedDate: Date?
    var progress: Double // текущий прогресс 0-100%
    
    init(id: UUID = UUID(), title: String, description: String, iconName: String, category: AchievementCategory, requirement: Double, isUnlocked: Bool = false, unlockedDate: Date? = nil, progress: Double = 0.0) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
        self.category = category
        self.requirement = requirement
        self.isUnlocked = isUnlocked
        self.unlockedDate = unlockedDate
        self.progress = progress
    }
    
    var progressColor: Color {
        if isUnlocked {
            return Color(hex: "00FF88")
        } else if progress > 50 {
            return Color(hex: "00F9FF")
        } else {
            return Color(hex: "8A8F98")
        }
    }
}

enum AchievementCategory: String, CaseIterable, Codable {
    case streak = "Streak"
    case performance = "Performance"
    case consistency = "Consistency"
    case mastery = "Mastery"
    case dedication = "Dedication"
    
    var color: Color {
        switch self {
        case .streak: return Color(hex: "FF0055")
        case .performance: return Color(hex: "00F9FF")
        case .consistency: return Color(hex: "006872")
        case .mastery: return Color(hex: "6C5CE7")
        case .dedication: return Color(hex: "00FF88")
        }
    }
}

