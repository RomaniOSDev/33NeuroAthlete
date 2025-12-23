//
//  ProfileAnalyticsView.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI

struct ProfileAnalyticsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "071224")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text("Analytics")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    // Overall Score
                    overallScoreCard
                    
                    // Baseline Scores
                    baselineScoresSection
                    
                    // Streak Info
                    streakSection
                    
                    // Fatigue Trend
                    fatigueTrendSection
                    
                    // Peak Performance Time
                    peakPerformanceSection
                }
            }
        }
    }
    
    private var overallScoreCard: some View {
        VStack(spacing: 16) {
            Text("Overall Neuro Score")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(hex: "8A8F98"))
            
            Text("\(Int(viewModel.profile.overallScore))")
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: Color(hex: "00F9FF").opacity(0.8), radius: 20)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "0F1A2A").opacity(0.6))
        )
        .padding(.horizontal)
    }
    
    private var baselineScoresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Baseline Scores")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
            
            ForEach(TestType.allCases, id: \.self) { testType in
                if let score = viewModel.profile.baselineScores[testType] {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(testType.rawValue)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(Int(score))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: "00F9FF"))
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(hex: "1A1F2E"))
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "006872"), Color(hex: "00F9FF")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * CGFloat(score / 100), height: 8)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "0F1A2A").opacity(0.6))
                    )
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var streakSection: some View {
        HStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("\(viewModel.profile.currentStreak)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(hex: "FF0055"))
                
                Text("Current Streak")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "8A8F98"))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "0F1A2A").opacity(0.6))
            )
            
            VStack(spacing: 8) {
                Text("\(viewModel.profile.bestStreak)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(hex: "00FF88"))
                
                Text("Best Streak")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "8A8F98"))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "0F1A2A").opacity(0.6))
            )
        }
        .padding(.horizontal)
    }
    
    private var fatigueTrendSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cognitive Fatigue Trend")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
            
            if viewModel.profile.cognitiveFatigueTrend.isEmpty {
                Text("No data available")
                    .foregroundColor(Color(hex: "8A8F98"))
                    .padding()
            } else {
                // Simple bar chart
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(Array(viewModel.profile.cognitiveFatigueTrend.enumerated()), id: \.offset) { index, value in
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(value > 70 ? Color(hex: "FF4757") :
                                      value > 40 ? Color(hex: "FF0055") :
                                      Color(hex: "00FF88"))
                                .frame(width: 30, height: CGFloat(value) * 2)
                            
                            Text("\(index + 1)")
                                .font(.system(size: 10))
                                .foregroundColor(Color(hex: "8A8F98"))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "0F1A2A").opacity(0.6))
        )
        .padding(.horizontal)
    }
    
    private var peakPerformanceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Peak Performance Time")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            if let peakTime = viewModel.profile.peakPerformanceTime {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(Color(hex: "00F9FF"))
                    
                    Text(peakTime.rawValue)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
            } else {
                Text("Not enough data")
                    .foregroundColor(Color(hex: "8A8F98"))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "0F1A2A").opacity(0.6))
        )
        .padding(.horizontal)
    }
}

