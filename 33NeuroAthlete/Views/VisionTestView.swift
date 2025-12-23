//
//  VisionTestView.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI

struct VisionTestView: View {
    @ObservedObject var viewModel: TestViewModel
    let test: CognitiveTest
    @Environment(\.dismiss) var dismiss
    @State private var testStartTime: Date?
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var targetTimer: Timer?
    @State private var attempts = 0
    
    var body: some View {
        ZStack {
            Color(hex: "071224")
                .ignoresSafeArea()
            
            // Center fixation point
            Circle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 10, height: 10)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            
            // Peripheral targets
            ForEach(viewModel.visionTargets) { target in
                Circle()
                    .fill(Color(hex: "6C5CE7"))
                    .frame(width: 50, height: 50)
                    .shadow(color: Color(hex: "6C5CE7").opacity(0.8), radius: 15)
                    .position(target.position)
                    .onTapGesture {
                        handleTap(target: target)
                    }
                    .overlay(
                        Circle()
                            .stroke(Color(hex: "00F9FF"), lineWidth: 2)
                            .frame(width: 50, height: 50)
                    )
            }
            
            VStack {
                // Header
                HStack {
                    Button("Close") {
                        endTest()
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(Int(elapsedTime))s")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Hits: \(attempts)")
                        .foregroundColor(Color(hex: "8A8F98"))
                }
                .padding()
                
                Spacer()
                
                // Instructions
                VStack(spacing: 8) {
                    Text("Keep your eyes on the center")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "00F9FF"))
                    
                    ForEach(test.instructions, id: \.self) { instruction in
                        Text(instruction)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "8A8F98"))
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "0F1A2A").opacity(0.6))
                )
                
                Spacer()
            }
        }
        .onAppear {
            startTest()
        }
        .onDisappear {
            timer?.invalidate()
            targetTimer?.invalidate()
        }
    }
    
    private func startTest() {
        testStartTime = Date()
        viewModel.startTest(test)
        startTimer()
        startTargetGeneration()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let startTime = testStartTime {
                elapsedTime = Date().timeIntervalSince(startTime)
                
                if elapsedTime >= test.duration {
                    endTest()
                }
            }
        }
    }
    
    private func startTargetGeneration() {
        targetTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            if viewModel.isTestRunning {
                viewModel.generateVisionTarget()
            }
        }
        
        // Generate first target immediately
        viewModel.generateVisionTarget()
    }
    
    private func handleTap(target: VisionTarget) {
        let reactionTime = Date().timeIntervalSince(target.appearedAt) * 1000 // ms
        
        viewModel.testResults.correctResponses += 1
        if let current = viewModel.testResults.reactionTime {
            viewModel.testResults.reactionTime = (current + reactionTime) / 2
        } else {
            viewModel.testResults.reactionTime = reactionTime
        }
        
        attempts += 1
        
        // Remove tapped target
        if let index = viewModel.visionTargets.firstIndex(where: { $0.id == target.id }) {
            viewModel.visionTargets.remove(at: index)
        }
    }
    
    private func endTest() {
        timer?.invalidate()
        targetTimer?.invalidate()
        viewModel.endTest()
        dismiss()
    }
}

