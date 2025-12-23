//
//  AttentionTestView.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI

struct AttentionTestView: View {
    @ObservedObject var viewModel: TestViewModel
    let test: CognitiveTest
    @Environment(\.dismiss) var dismiss
    @State private var testStartTime: Date?
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var animationTimer: Timer?
    
    var body: some View {
        ZStack {
            Color(hex: "071224")
                .ignoresSafeArea()
            
            // Moving targets
            ForEach(viewModel.attentionTargets) { target in
                Circle()
                    .fill(target.isTarget ? Color(hex: "006872") : Color(hex: "8A8F98").opacity(0.3))
                    .frame(width: target.isTarget ? 50 : 40, height: target.isTarget ? 50 : 40)
                    .overlay(
                        Circle()
                            .stroke(target.isTarget ? Color(hex: "00F9FF") : Color.clear, lineWidth: 3)
                    )
                    .position(target.position)
                    .shadow(color: target.isTarget ? Color(hex: "006872").opacity(0.8) : Color.clear, radius: 15)
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
                    
                    Text("Track the target")
                        .foregroundColor(Color(hex: "8A8F98"))
                }
                .padding()
                
                Spacer()
                
                // Instructions
                VStack(spacing: 8) {
                    ForEach(test.instructions, id: \.self) { instruction in
                        Text(instruction)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "8A8F98"))
                    }
                }
                .padding()
            }
        }
        .onAppear {
            startTest()
        }
        .onDisappear {
            timer?.invalidate()
            animationTimer?.invalidate()
        }
    }
    
    private func startTest() {
        testStartTime = Date()
        viewModel.startTest(test)
        startTimer()
        startAnimation()
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
    
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            updateTargetPositions()
        }
    }
    
    private func updateTargetPositions() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        viewModel.updateAttentionTargetPositions(screenWidth: screenWidth, screenHeight: screenHeight)
    }
    
    private func endTest() {
        timer?.invalidate()
        animationTimer?.invalidate()
        viewModel.endTest()
        dismiss()
    }
}

