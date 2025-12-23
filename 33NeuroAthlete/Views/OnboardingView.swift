//
//  OnboardingView.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color(hex: "071224")
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingPages.count, id: \.self) { index in
                    OnboardingPageView(page: onboardingPages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            VStack {
                Spacer()
                
                // Skip Button
                if currentPage < onboardingPages.count - 1 {
                    HStack {
                        Spacer()
                        Button("Skip") {
                            completeOnboarding()
                        }
                        .foregroundColor(Color(hex: "8A8F98"))
                        .padding()
                    }
                }
                
                // Next/Get Started Button
                Button(action: {
                    if currentPage < onboardingPages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        completeOnboarding()
                    }
                }) {
                    Text(currentPage < onboardingPages.count - 1 ? "Next" : "Get Started")
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
                .padding(.bottom, 40)
            }
        }
    }
    
    private func completeOnboarding() {
        hasCompletedOnboarding = true
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon/Illustration
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                page.accentColor.opacity(0.3),
                                page.accentColor.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 50,
                            endRadius: 150
                        )
                    )
                    .frame(width: 250, height: 250)
                    .blur(radius: 30)
                
                Image(systemName: page.iconName)
                    .font(.system(size: 80))
                    .foregroundColor(page.accentColor)
                    .shadow(color: page.accentColor.opacity(0.5), radius: 20)
            }
            
            // Content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: page.accentColor.opacity(0.3), radius: 10)
                
                Text(page.description)
                    .font(.system(size: 18))
                    .foregroundColor(Color(hex: "8A8F98"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct OnboardingPage {
    let iconName: String
    let title: String
    let description: String
    let accentColor: Color
}

private let onboardingPages: [OnboardingPage] = [
    OnboardingPage(
        iconName: "brain.head.profile",
        title: "Train Your Mind",
        description: "Enhance your cognitive performance with scientifically designed tests for athletes",
        accentColor: Color(hex: "00F9FF")
    ),
    OnboardingPage(
        iconName: "chart.line.uptrend.xyaxis",
        title: "Track Progress",
        description: "Monitor your cognitive improvements and identify your peak performance times",
        accentColor: Color(hex: "006872")
    ),
    OnboardingPage(
        iconName: "trophy.fill",
        title: "Achieve Excellence",
        description: "Unlock achievements, complete training programs, and become a neuro athlete",
        accentColor: Color(hex: "FF0055")
    )
]

