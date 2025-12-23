//
//  ReactionTestView.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI

struct ReactionTestView: View {
    @ObservedObject var viewModel: TestViewModel
    let test: CognitiveTest
    @Environment(\.dismiss) var dismiss
    @State private var testStartTime: Date?
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var attempts = 0
    @State private var showExplosion = false
    @State private var explosionPosition: CGPoint = .zero
    
    var body: some View {
        ZStack {
            Color(hex: "071224")
                .ignoresSafeArea()
            
            // Targets
            ForEach(viewModel.reactionTargets) { target in
                Circle()
                    .fill(target.color)
                    .frame(width: 60, height: 60)
                    .shadow(color: target.color.opacity(0.8), radius: 20)
                    .position(target.position)
                    .onTapGesture {
                        handleTap(target: target)
                    }
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            .frame(width: 60, height: 60)
                    )
            }
            
            // Explosion effect
            if showExplosion {
                ExplosionView(position: explosionPosition)
                    .transition(.scale.combined(with: .opacity))
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
                        .shadow(color: Color(hex: "00F9FF").opacity(0.5), radius: 10)
                    
                    Spacer()
                    
                    Text("Attempts: \(attempts)")
                        .foregroundColor(Color(hex: "8A8F98"))
                }
                .padding()
                
                Spacer()
                
                // Reaction time display
                if let reactionTime = viewModel.currentReactionTime {
                    VStack(spacing: 8) {
                        Text("\(Int(reactionTime)) ms")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(Color(hex: "00F9FF"))
                            .shadow(color: Color(hex: "00F9FF").opacity(0.8), radius: 15)
                        
                        Text("Reaction Time")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "8A8F98"))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "0F1A2A").opacity(0.8))
                    )
                }
                
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
        }
    }
    
    private func startTest() {
        testStartTime = Date()
        viewModel.startTest(test)
        startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let startTime = testStartTime {
                elapsedTime = Date().timeIntervalSince(startTime)
                
                // Check if test duration exceeded
                if elapsedTime >= test.duration {
                    endTest()
                }
            }
        }
    }
    
    private func handleTap(target: ReactionTarget) {
        guard let startTime = viewModel.reactionStartTime else { return }
        
        let reactionTime = Date().timeIntervalSince(startTime) * 1000 // ms
        viewModel.currentReactionTime = reactionTime
        
        explosionPosition = target.position
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            showExplosion = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            showExplosion = false
        }
        
        viewModel.handleReactionTap(at: target.position, targetId: target.id)
        attempts += 1
    }
    
    private func endTest() {
        timer?.invalidate()
        viewModel.endTest()
        dismiss()
    }
}

struct ExplosionView: View {
    let position: CGPoint
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            ForEach(0..<8) { index in
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "00F9FF"), Color(hex: "FF0055")],
                            startPoint: .center,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 20, height: 20)
                    .offset(
                        x: cos(Double(index) * .pi / 4) * 40,
                        y: sin(Double(index) * .pi / 4) * 40
                    )
                    .scaleEffect(scale)
                    .opacity(opacity)
            }
        }
        .position(position)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                scale = 2.0
                opacity = 0
            }
        }
    }
}

