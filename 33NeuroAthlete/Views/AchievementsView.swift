//
//  AchievementsView.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var viewModel: AchievementViewModel
    @State private var selectedCategory: AchievementCategory?
    
    var filteredAchievements: [Achievement] {
        if let category = selectedCategory {
            return viewModel.achievements.filter { $0.category == category }
        }
        return viewModel.achievements
    }
    
    var body: some View {
        ZStack {
            Color(hex: "071224")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Category Filter
                    categoryFilter
                    
                    // Achievements Grid
                    achievementsGrid
                }
                .padding()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Achievements")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: Color(hex: "00F9FF").opacity(0.5), radius: 10)
            
            HStack {
                Text("\(viewModel.unlockedCount)/\(viewModel.achievements.count) unlocked")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "8A8F98"))
                
                Spacer()
                
                // Progress Ring
                ZStack {
                    Circle()
                        .stroke(Color(hex: "1A1F2E"), lineWidth: 8)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(viewModel.unlockedCount) / CGFloat(viewModel.achievements.count))
                        .stroke(
                            LinearGradient(
                                colors: [Color(hex: "00F9FF"), Color(hex: "006872")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int((Double(viewModel.unlockedCount) / Double(viewModel.achievements.count)) * 100))%")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryButton(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    color: Color(hex: "00F9FF")
                ) {
                    selectedCategory = nil
                }
                
                ForEach(AchievementCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        color: category.color
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    private var achievementsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(filteredAchievements) { achievement in
                AchievementCardView(achievement: achievement)
            }
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? .white : Color(hex: "8A8F98"))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? color.opacity(0.3) : Color(hex: "0F1A2A").opacity(0.6))
                        .overlay(
                            Capsule()
                                .stroke(isSelected ? color : Color.clear, lineWidth: 2)
                        )
                )
        }
    }
}

struct AchievementCardView: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        achievement.isUnlocked ?
                        LinearGradient(
                            colors: [achievement.category.color.opacity(0.3), achievement.category.color.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [Color(hex: "1A1F2E"), Color(hex: "0F1A2A")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                
                Image(systemName: achievement.iconName)
                    .font(.system(size: 32))
                    .foregroundColor(
                        achievement.isUnlocked ?
                        achievement.category.color :
                        Color(hex: "8A8F98")
                    )
                    .opacity(achievement.isUnlocked ? 1.0 : 0.5)
            }
            .overlay(
                Circle()
                    .stroke(
                        achievement.isUnlocked ?
                        achievement.category.color :
                        Color(hex: "1A1F2E"),
                        lineWidth: 2
                    )
            )
            
            // Title
            Text(achievement.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Description
            Text(achievement.description)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "8A8F98"))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Progress Bar
            if !achievement.isUnlocked {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(hex: "1A1F2E"))
                            .frame(height: 4)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(achievement.progressColor)
                            .frame(width: geometry.size.width * CGFloat(achievement.progress / 100), height: 4)
                    }
                }
                .frame(height: 4)
            } else {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "00FF88"))
                        .font(.system(size: 12))
                    
                    if let date = achievement.unlockedDate {
                        Text("Unlocked")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "00FF88"))
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "0F1A2A").opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            achievement.isUnlocked ?
                            achievement.category.color.opacity(0.3) :
                            Color.clear,
                            lineWidth: 1
                        )
                )
        )
    }
}

