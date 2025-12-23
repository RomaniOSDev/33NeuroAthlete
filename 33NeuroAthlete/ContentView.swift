//
//  ContentView.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI
import Combine

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @StateObject private var testViewModel = TestViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var fatigueViewModel = FatigueViewModel()
    @StateObject private var trainingViewModel = TrainingViewModel()
    @StateObject private var achievementViewModel = AchievementViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView()
            } else {
                TabView(selection: $selectedTab) {
                    MainDashboardView(
                        testViewModel: testViewModel,
                        profileViewModel: profileViewModel,
                        fatigueViewModel: fatigueViewModel
                    )
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Dashboard")
                    }
                    .tag(0)
                    
                    TrainingProgramsView(
                        viewModel: trainingViewModel,
                        testViewModel: testViewModel
                    )
                    .tabItem {
                        Image(systemName: "list.bullet.clipboard.fill")
                        Text("Programs")
                    }
                    .tag(1)
                    
                    AchievementsView(viewModel: achievementViewModel)
                        .tabItem {
                            Image(systemName: "trophy.fill")
                            Text("Achievements")
                        }
                        .tag(2)
                    
                    ProfileAnalyticsView(viewModel: profileViewModel)
                        .tabItem {
                            Image(systemName: "chart.bar.fill")
                            Text("Analytics")
                        }
                        .tag(3)
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                        .tag(4)
                }
                .accentColor(Color(hex: "00F9FF"))
            }
        }
        .onAppear {
            setupViewModels()
        }
    }
    
    @State private var cancellables = Set<AnyCancellable>()
    
    private func setupViewModels() {
        // Observe test sessions changes and update profile
        testViewModel.$testSessions
            .sink { sessions in
                profileViewModel.testSessions = sessions
                profileViewModel.updateBaselineScores(from: sessions)
                profileViewModel.updateStreak()
                profileViewModel.updateFatigueTrend(from: sessions)
                profileViewModel.determinePeakPerformanceTime(from: sessions)
                
                // Update achievements
                let bestReactionTime = sessions.compactMap { $0.results.reactionTime }.min()
                let bestAccuracy = sessions.compactMap { $0.results.accuracy }.max()
                let consistencyScore = sessions.compactMap { $0.results.consistencyScore }.average
                
                achievementViewModel.updateAchievements(
                    streak: profileViewModel.profile.currentStreak,
                    totalTests: sessions.count,
                    bestReactionTime: bestReactionTime,
                    bestAccuracy: bestAccuracy,
                    overallScore: profileViewModel.profile.overallScore,
                    consistencyScore: consistencyScore
                )
                
                // Update training programs completion
                trainingViewModel.updateProgramProgress(sessions: sessions)
            }
            .store(in: &cancellables)
    }
}

#Preview {
    ContentView()
}
