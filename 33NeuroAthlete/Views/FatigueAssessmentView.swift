//
//  FatigueAssessmentView.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI

struct FatigueAssessmentView: View {
    @ObservedObject var viewModel: FatigueViewModel
    @ObservedObject var testViewModel: TestViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            Color(hex: "071224")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text("Fatigue Assessment")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    // Subjective Score
                    subjectiveScoreSection
                    
                    // Objective Score
                    if let assessment = viewModel.currentAssessment {
                        objectiveScoreSection(assessment)
                        
                        // Recommendations
                        recommendationsSection(assessment)
                        
                        // Recovery Time
                        recoveryTimeSection(assessment)
                    }
                    
                    // Assess Button
                    Button(action: {
                        viewModel.assessFatigue(
                            sessions: testViewModel.testSessions,
                            profile: profileViewModel.profile
                        )
                    }) {
                        Text("Assess Fatigue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "006872"), Color(hex: "00F9FF")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private var subjectiveScoreSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How tired do you feel?")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Text("\(viewModel.subjectiveScore)/10")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(
                    viewModel.subjectiveScore > 7 ? Color(hex: "FF4757") :
                    viewModel.subjectiveScore > 4 ? Color(hex: "FF0055") :
                    Color(hex: "00FF88")
                )
            
            Slider(value: Binding(
                get: { Double(viewModel.subjectiveScore) },
                set: { viewModel.updateSubjectiveScore(Int($0)) }
            ), in: 1...10, step: 1)
            .tint(Color(hex: "00F9FF"))
            
            HStack {
                Text("Fresh")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "8A8F98"))
                
                Spacer()
                
                Text("Exhausted")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "8A8F98"))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "0F1A2A").opacity(0.6))
        )
        .padding(.horizontal)
    }
    
    private func objectiveScoreSection(_ assessment: CognitiveFatigueAssessment) -> some View {
        VStack(spacing: 16) {
            Text("Objective Score")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Text("\(Int(assessment.objectiveScore))%")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(
                    assessment.objectiveScore > 70 ? Color(hex: "FF4757") :
                    assessment.objectiveScore > 40 ? Color(hex: "FF0055") :
                    Color(hex: "00FF88")
                )
                .shadow(
                    color: (assessment.objectiveScore > 70 ? Color(hex: "FF4757") :
                           assessment.objectiveScore > 40 ? Color(hex: "FF0055") :
                           Color(hex: "00FF88")).opacity(0.5),
                    radius: 15
                )
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: "1A1F2E"))
                        .frame(height: 20)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [
                                    assessment.objectiveScore > 70 ? Color(hex: "FF4757") :
                                    assessment.objectiveScore > 40 ? Color(hex: "FF0055") :
                                    Color(hex: "00FF88"),
                                    assessment.objectiveScore > 70 ? Color(hex: "FF0055") :
                                    assessment.objectiveScore > 40 ? Color(hex: "FF4757") :
                                    Color(hex: "00F9FF")
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(assessment.objectiveScore / 100), height: 20)
                }
            }
            .frame(height: 20)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "0F1A2A").opacity(0.6))
        )
        .padding(.horizontal)
    }
    
    private func recommendationsSection(_ assessment: CognitiveFatigueAssessment) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recommendations")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(hex: "00F9FF"))
            
            ForEach(assessment.recommendations, id: \.self) { recommendation in
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(Color(hex: "00F9FF"))
                        .frame(width: 8, height: 8)
                        .padding(.top, 6)
                    
                    Text(recommendation)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "8A8F98"))
                }
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
    
    private func recoveryTimeSection(_ assessment: CognitiveFatigueAssessment) -> some View {
        HStack {
            Image(systemName: "clock.fill")
                .foregroundColor(Color(hex: "00F9FF"))
                .font(.system(size: 24))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Recovery Time")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "8A8F98"))
                
                Text(viewModel.getRecoveryTimeString())
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "0F1A2A").opacity(0.6))
        )
        .padding(.horizontal)
    }
}

