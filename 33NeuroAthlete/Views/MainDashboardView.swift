//
//  MainDashboardView.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI

struct MainDashboardView: View {
    @ObservedObject var testViewModel: TestViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var fatigueViewModel: FatigueViewModel
    @State private var selectedTest: CognitiveTest?
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "071224")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    headerSection
                    
                    // Neuro Status Sphere
                    neuroStatusSphere
                    
                    // Quick Test Access
                    quickTestGrid
                    
                    // Cognitive Fatigue Indicator
                    fatigueIndicator
                    
                    // Streak
                    streakSection
                    
                    // Recommendation
                    recommendationSection
                }
                .padding()
            }
        }
        .sheet(item: $selectedTest) { test in
            testView(for: test)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Neuro Athlete")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: Color(hex: "00F9FF").opacity(0.5), radius: 10)
            
            Text("Cognitive Performance Training")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "8A8F98"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var neuroStatusSphere: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(hex: "00F9FF").opacity(0.3),
                            Color(hex: "006872").opacity(0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 50,
                        endRadius: 150
                    )
                )
                .frame(width: 200, height: 200)
                .blur(radius: 20)
            
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "00F9FF"), Color(hex: "006872")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
                .frame(width: 180, height: 180)
            
            VStack(spacing: 8) {
                Text("\(Int(profileViewModel.profile.overallScore))")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: Color(hex: "00F9FF").opacity(0.8), radius: 10)
                
                Text("Neuro Score")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "8A8F98"))
            }
        }
        .padding(.vertical)
    }
    
    private var quickTestGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Tests")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(testViewModel.availableTests) { test in
                    TestCardView(test: test) {
                        selectedTest = test
                    }
                }
            }
        }
    }
    
    private var fatigueIndicator: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cognitive Fatigue")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            let fatigueScore = profileViewModel.profile.cognitiveFatigueTrend.last ?? 0
            let fatigueColor = fatigueScore > 70 ? Color(hex: "FF4757") :
                              fatigueScore > 40 ? Color(hex: "FF0055") :
                              Color(hex: "00FF88")
            
            HStack {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "1A1F2E"))
                            .frame(height: 20)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [fatigueColor.opacity(0.8), fatigueColor],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(fatigueScore / 100), height: 20)
                    }
                }
                .frame(height: 20)
                
                Text("\(Int(fatigueScore))%")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(fatigueColor)
                    .frame(width: 50)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "0F1A2A").opacity(0.6))
        )
    }
    
    private var streakSection: some View {
        HStack {
            Image(systemName: "flame.fill")
                .foregroundColor(Color(hex: "FF0055"))
                .font(.system(size: 24))
            
            Text("\(profileViewModel.profile.currentStreak) day streak")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "0F1A2A").opacity(0.6))
        )
    }
    
    private var recommendationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recommendation")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "00F9FF"))
            
            Text("Optimal time for reaction training")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "8A8F98"))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "0F1A2A").opacity(0.6))
        )
    }
    
    @ViewBuilder
    private func testView(for test: CognitiveTest) -> some View {
        switch test.type {
        case .reaction:
            ReactionTestView(viewModel: testViewModel, test: test)
        case .attention:
            AttentionTestView(viewModel: testViewModel, test: test)
        case .decision:
            DecisionTestView(viewModel: testViewModel, test: test)
        case .vision:
            VisionTestView(viewModel: testViewModel, test: test)
        }
    }
}

struct TestCardView: View {
    let test: CognitiveTest
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Circle()
                        .fill(test.accentColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: iconForTestType(test.type))
                                .foregroundColor(test.accentColor)
                        )
                    
                    Spacer()
                }
                
                Text(test.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Text(test.difficulty.rawValue)
                    .font(.system(size: 12))
                    .foregroundColor(test.difficulty.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(test.difficulty.color.opacity(0.2))
                    )
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "0F1A2A").opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(test.accentColor.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    private func iconForTestType(_ type: TestType) -> String {
        switch type {
        case .reaction: return "bolt.fill"
        case .attention: return "eye.fill"
        case .decision: return "brain.head.profile"
        case .vision: return "viewfinder"
        }
    }
}

