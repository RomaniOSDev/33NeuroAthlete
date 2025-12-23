//
//  SettingsView.swift
//  33NeuroAthlete
//
//  Created by Роман Главацкий on 20.12.2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @State private var showPrivacy = false
    @State private var showTerms = false
    
    var body: some View {
        ZStack {
            Color(hex: "071224")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // App Info
                    appInfoSection
                    
                    // Legal
                    legalSection
                    
                    // Other
                    otherSection
                }
                .padding()
            }
        }
        .sheet(isPresented: $showPrivacy) {
            LegalDocumentView(title: "Privacy Policy", content: privacyPolicyContent)
        }
        .sheet(isPresented: $showTerms) {
            LegalDocumentView(title: "Terms of Service", content: termsOfServiceContent)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Settings")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: Color(hex: "00F9FF").opacity(0.5), radius: 10)
            
            Text("App preferences and information")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "8A8F98"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 12) {
            SettingsRow(
                icon: "info.circle.fill",
                title: "App Version",
                value: "1.0.0",
                iconColor: Color(hex: "00F9FF")
            )
            
            SettingsRow(
                icon: "star.fill",
                title: "Rate Us",
                value: nil,
                iconColor: Color(hex: "FF0055")
            ) {
                rateApp()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "0F1A2A").opacity(0.6))
        )
    }
    
    private var legalSection: some View {
        VStack(spacing: 12) {
            SettingsRow(
                icon: "lock.shield.fill",
                title: "Privacy Policy",
                value: nil,
                iconColor: Color(hex: "006872")
            ) {
                if let url = URL(string: "https://www.termsfeed.com/live/57c4682b-e50b-4172-b26d-9f5fc762adcd") {
                    UIApplication.shared.open(url)
                }
            }
            
            SettingsRow(
                icon: "doc.text.fill",
                title: "Terms of Service",
                value: nil,
                iconColor: Color(hex: "6C5CE7")
            ) {
                if let url = URL(string: "https://www.termsfeed.com/live/b7847fe9-3a1a-4e74-a3b6-309dc76d9f4f") {
                    UIApplication.shared.open(url)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "0F1A2A").opacity(0.6))
        )
    }
    
    private var otherSection: some View {
        VStack(spacing: 12) {
            SettingsRow(
                icon: "arrow.counterclockwise",
                title: "Reset Data",
                value: nil,
                iconColor: Color(hex: "FF4757")
            ) {
                // Reset functionality would go here
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "0F1A2A").opacity(0.6))
        )
    }
    
    private func rateApp() {
        SKStoreReviewController.requestReview()
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let value: String?
    let iconColor: Color
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                if let value = value {
                    Text(value)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "8A8F98"))
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(hex: "8A8F98"))
                        .font(.system(size: 14))
                }
            }
            .padding(.vertical, 4)
        }
    }
}

struct LegalDocumentView: View {
    let title: String
    let content: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "071224")
                    .ignoresSafeArea()
                
                ScrollView {
                    Text(content)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

// MARK: - Legal Content
private let privacyPolicyContent = """
PRIVACY POLICY

Last updated: December 20, 2025

1. INFORMATION WE COLLECT

Neuro Athlete collects minimal data necessary for app functionality:
- Test results and performance metrics
- Training session data
- Cognitive fatigue assessments
- Usage statistics

2. HOW WE USE YOUR INFORMATION

We use collected information to:
- Provide personalized training recommendations
- Track your cognitive performance progress
- Improve app functionality
- Generate analytics and insights

3. DATA STORAGE

All data is stored locally on your device. We do not transmit your personal data to external servers without your explicit consent.

4. DATA SHARING

We do not sell, trade, or share your personal information with third parties.

5. YOUR RIGHTS

You have the right to:
- Access your data
- Delete your data
- Export your data
- Opt-out of data collection

6. CONTACT US

For privacy-related questions, contact us at: privacy@neuroathlete.app
"""

private let termsOfServiceContent = """
TERMS OF SERVICE

Last updated: December 20, 2025

1. ACCEPTANCE OF TERMS

By using Neuro Athlete, you agree to these Terms of Service.

2. USE OF THE APP

You agree to use Neuro Athlete:
- For personal cognitive training purposes
- In compliance with all applicable laws
- Without attempting to reverse engineer the app

3. DISCLAIMER

Neuro Athlete is provided "as is" without warranties. Results may vary based on individual performance.

4. LIMITATION OF LIABILITY

Neuro Athlete is not responsible for any decisions made based on app data or recommendations.

5. INTELLECTUAL PROPERTY

All content and features of Neuro Athlete are protected by copyright and intellectual property laws.

6. MODIFICATIONS

We reserve the right to modify these terms at any time. Continued use constitutes acceptance of changes.

7. CONTACT US

For questions about these terms, contact us at: support@neuroathlete.app
"""

