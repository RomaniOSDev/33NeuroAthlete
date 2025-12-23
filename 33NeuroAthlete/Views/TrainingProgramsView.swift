//
//  TrainingProgramsView.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI

struct TrainingProgramsView: View {
    @ObservedObject var viewModel: TrainingViewModel
    @ObservedObject var testViewModel: TestViewModel
    @State private var selectedProgram: TrainingProgram?
    
    var body: some View {
        ZStack {
            Color(hex: "071224")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Active Program
                    if let activeProgram = viewModel.activeProgram {
                        activeProgramSection(activeProgram)
                    }
                    
                    // All Programs
                    allProgramsSection
                }
                .padding()
            }
        }
        .sheet(item: $selectedProgram) { program in
            ProgramDetailView(program: program, viewModel: viewModel, testViewModel: testViewModel)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Training Programs")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: Color(hex: "00F9FF").opacity(0.5), radius: 10)
            
            Text("Structured cognitive training plans")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "8A8F98"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func activeProgramSection(_ program: TrainingProgram) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Active Program")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(hex: "00F9FF"))
                
                Spacer()
                
                Button(action: {
                    viewModel.deactivateProgram(program)
                }) {
                    Text("Deactivate")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "FF4757"))
                }
            }
            
            ProgramCardView(program: program, isActive: true) {
                selectedProgram = program
            }
        }
    }
    
    private var allProgramsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Available Programs")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
            
            ForEach(viewModel.programs) { program in
                ProgramCardView(program: program, isActive: program.isActive) {
                    selectedProgram = program
                }
            }
        }
    }
}

struct ProgramCardView: View {
    let program: TrainingProgram
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(program.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(program.description)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "8A8F98"))
                    }
                    
                    Spacer()
                    
                    if isActive {
                        Circle()
                            .fill(Color(hex: "00FF88"))
                            .frame(width: 12, height: 12)
                    }
                }
                
                HStack(spacing: 16) {
                    Label("\(program.durationDays) days", systemImage: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "8A8F98"))
                    
                    Label("\(program.dailySessions)/day", systemImage: "repeat")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "8A8F98"))
                    
                    Label("\(Int(program.targetImprovement))% improvement", systemImage: "arrow.up.right")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "8A8F98"))
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "1A1F2E"))
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [program.focusArea.accentColor, program.focusArea.accentColor.opacity(0.6)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(program.completionRate / 100), height: 6)
                    }
                }
                .frame(height: 6)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "0F1A2A").opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isActive ? program.focusArea.accentColor : Color.clear, lineWidth: 2)
                    )
            )
        }
    }
}

struct ProgramDetailView: View {
    let program: TrainingProgram
    @ObservedObject var viewModel: TrainingViewModel
    @ObservedObject var testViewModel: TestViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "071224")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    HStack {
                        Text(program.name)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button("Close") {
                            dismiss()
                        }
                        .foregroundColor(.white)
                    }
                    
                    Text(program.description)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "8A8F98"))
                    
                    // Program Info
                    VStack(alignment: .leading, spacing: 16) {
                        InfoRow(icon: "calendar", title: "Duration", value: "\(program.durationDays) days")
                        InfoRow(icon: "repeat", title: "Daily Sessions", value: "\(program.dailySessions)")
                        InfoRow(icon: "arrow.up.right", title: "Target Improvement", value: "\(Int(program.targetImprovement))%")
                        InfoRow(icon: "target", title: "Focus Area", value: program.focusArea.rawValue)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "0F1A2A").opacity(0.6))
                    )
                    
                    // Action Button
                    if !program.isActive {
                        Button(action: {
                            viewModel.activateProgram(program)
                            dismiss()
                        }) {
                            Text("Start Program")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                colors: [program.focusArea.accentColor, program.focusArea.accentColor.opacity(0.6)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                )
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "00F9FF"))
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "8A8F98"))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

extension TestType {
    var accentColor: Color {
        switch self {
        case .reaction: return Color(hex: "FF0055")
        case .attention: return Color(hex: "006872")
        case .decision: return Color(hex: "00F9FF")
        case .vision: return Color(hex: "6C5CE7")
        }
    }
}

