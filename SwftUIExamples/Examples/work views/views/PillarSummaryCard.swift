//
//  PillarSummaryCard.swift
//  Doc App
//
//  Created by Carlos Jaramillo on 26/11/25.
//

import SwiftUI

// MARK: - Stat Box Component
struct StatBox: View {
    let value: String
    let unit: String
    let iconName: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(iconName)
                .font(.system(size: 20))
                .foregroundColor(color.opacity(0.8))
        }
        .padding(12)
        .background(Color.white.opacity(0.6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.25), lineWidth: 1)
        )
    }
}

// MARK: - Generic Health Card
// MARK: - Generic Health Card
struct PillarSummaryCard<Content: View>: View {
    
    let title: String
    let icon: String // Asset name
    let color: Color
    let score: Int
    let totalScore: Int
    let summary: String
    let content: Content
    
    init(
        title: String,
        icon: String, // Asset name
        color: Color,
        score: Int = 100,
        totalScore: Int = 100,
        summary: String,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.score = score
        self.totalScore = totalScore
        self.summary = summary
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(icon)
                    .resizable()
                    .padding(4)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [color.opacity(0.0), color.opacity(0.05), color.opacity(0.1), color.opacity(0.25)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(color)
                
                Spacer()
                
                Text("\(score) / \(totalScore)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(15)
                    .foregroundColor(color)
            }
            
            Text(summary)
                .font(.footnote)
                .foregroundColor(.black.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(2)
            
            content
        }
        .padding(10)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [color.opacity(0.0), color.opacity(0.05), color.opacity(0.15), color.opacity(0.25)]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Core Vital Health Card (Specialized)
struct CoreVitalHealthCard: View {
    let systolic: Int
    let diastolic: Int
    let restingHeartRate: Int
    let summary: String
    let score: Int
    let totalScore: Int
    
    private let type = HealthMetricType.coreVital
    
    init(systolic: Int, diastolic: Int, restingHeartRate: Int, summary: String, score: Int = 100, totalScore: Int = 100) {
        self.systolic = systolic
        self.diastolic = diastolic
        self.restingHeartRate = restingHeartRate
        self.summary = summary
        self.score = score
        self.totalScore = totalScore
    }
    
    var body: some View {
        PillarSummaryCard(
            title: type.displayTitle,
            icon: type.icon,
            color: type.mainColor,
            score: score,
            totalScore: totalScore,
            summary: summary
        ) {
            HStack(spacing: 12) {
                StatBox(
                    value: "\(systolic)/\(diastolic)",
                    unit: "mmHg",
                    iconName: "icBloodPressure",
                    color: .red
                )
                
                StatBox(
                    value: "\(restingHeartRate)",
                    unit: "BPM",
                    iconName: "icHeartRate",
                    color: .red
                )
            }
            .padding(.top, 4)
        }
    }
}



#Preview {
    VStack(spacing: 20) {
        PillarSummaryCard(
            title: "Metabolic & Nutrition",
            icon: "icEatingHabits",
            color: Color.orange,
            score: 82,
            summary: "Your metabolic and nutrition balance can improve.\nA more structured eating schedule and nutrient rich meals will support your metabolism and boost your energy throughout the day."
        )
        
        PillarSummaryCard(
            title: "Mental & Cognitive",
            icon: "icPsychologist2",
            color: Color.blue,
            score: 44,
            summary: "This is your strongest area, reflecting good focus and emotional stability. Keep supporting this with proper rest, stress management, and activities that stimulate your mind and motivation."
        )
        CoreVitalHealthCard(systolic: 50,
                            diastolic: 10,
                            restingHeartRate: 20,
                            summary: "Your Central Vital Functions show a strong foundation, particularly in your cardiovascular health."
        )
    }
    .padding(20)
}

