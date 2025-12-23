//
//  DecisionTestView.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI

struct DecisionTestView: View {
    @ObservedObject var viewModel: TestViewModel
    let test: CognitiveTest
    @Environment(\.dismiss) var dismiss
    @State private var testStartTime: Date?
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var scenarioStartTime: Date?
    @State private var timeRemaining: TimeInterval = 0
    @State private var selectedAnswer: Int?
    
    var body: some View {
        ZStack {
            Color(hex: "071224")
                .ignoresSafeArea()
            
            if let scenario = viewModel.currentScenario {
                VStack(spacing: 30) {
                    // Header
                    HStack {
                        Button("Close") {
                            endTest()
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(Int(elapsedTime))s")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Scenario
                    VStack(spacing: 24) {
                        Text(scenario.question)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .shadow(color: Color(hex: "00F9FF").opacity(0.5), radius: 10)
                        
                        // Time remaining
                        if timeRemaining > 0 {
                            Text("\(String(format: "%.1f", timeRemaining))s")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(timeRemaining < 0.5 ? Color(hex: "FF4757") : Color(hex: "00F9FF"))
                        }
                        
                        // Options
                        VStack(spacing: 16) {
                            ForEach(0..<scenario.options.count, id: \.self) { index in
                                Button(action: {
                                    handleAnswer(index)
                                }) {
                                    Text(scenario.options[index])
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(selectedAnswer == index ? Color(hex: "00F9FF").opacity(0.3) : Color(hex: "0F1A2A").opacity(0.6))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(selectedAnswer == index ? Color(hex: "00F9FF") : Color.clear, lineWidth: 2)
                                                )
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            } else {
                ProgressView()
                    .tint(Color(hex: "00F9FF"))
            }
        }
        .onAppear {
            startTest()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startTest() {
        testStartTime = Date()
        viewModel.startTest(test)
        startTimer()
        startNewScenario()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let startTime = testStartTime {
                elapsedTime = Date().timeIntervalSince(startTime)
                
                if elapsedTime >= test.duration {
                    endTest()
                }
            }
            
            if let scenarioStart = scenarioStartTime, let scenario = viewModel.currentScenario {
                let elapsed = Date().timeIntervalSince(scenarioStart)
                timeRemaining = max(0, scenario.timeLimit - elapsed)
                
                if timeRemaining <= 0 && selectedAnswer == nil {
                    // Time's up
                    handleTimeUp()
                }
            }
        }
    }
    
    private func startNewScenario() {
        viewModel.generateDecisionScenario()
        scenarioStartTime = Date()
        selectedAnswer = nil
        
        if let scenario = viewModel.currentScenario {
            timeRemaining = scenario.timeLimit
        }
    }
    
    private func handleAnswer(_ answerIndex: Int) {
        guard let scenario = viewModel.currentScenario else { return }
        
        selectedAnswer = answerIndex
        
        let isCorrect = answerIndex == scenario.correctAnswer
        if isCorrect {
            viewModel.testResults.correctResponses += 1
        } else {
            viewModel.testResults.incorrectResponses += 1
        }
        
        // Move to next scenario after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if viewModel.isTestRunning {
                startNewScenario()
            }
        }
    }
    
    private func handleTimeUp() {
        viewModel.testResults.missedResponses += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if viewModel.isTestRunning {
                startNewScenario()
            }
        }
    }
    
    private func endTest() {
        timer?.invalidate()
        viewModel.endTest()
        dismiss()
    }
}

