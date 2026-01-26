//
//  OverallHealthCircularScoreView.swift
//  Doc App
//
//  Created by Carlos Jaramillo on 18/12/25.
//

import SwiftUI

struct OverallHealthCircularScoreView: View {
    
    let score: Int
    let summary: String
    let gaugeSize: CGFloat

    let backgroundColor: Color
    let scoreColor: Color        // used for the circle + score number
    let titleColor: Color        // used for the title text
    let summaryColor: Color      // used for the summary text

    init(
        score: Int,
        summary: String,
        gaugeSize: CGFloat,
        backgroundColor: Color,
        scoreColor: Color? = nil,
        titleColor: Color? = nil,
        summaryColor: Color? = nil
    ) {
        self.score = score
        self.summary = summary
        self.gaugeSize = gaugeSize
        self.backgroundColor = backgroundColor
        
        let calculatedColor = HealthScoreUtilities.getScoreColor(from: score)
        self.scoreColor = scoreColor ?? calculatedColor
        self.titleColor = titleColor ?? calculatedColor
        self.summaryColor = summaryColor ?? Color(red: 1/255, green: 62/255, blue: 50/255)
    }

    private var formattedSummary: AttributedString {
        if summary.isEmpty { return AttributedString("") }
        
        do {
            let options = AttributedString.MarkdownParsingOptions(interpretedSyntax: .full)
            return try AttributedString(markdown: summary, options: options)
        } catch {
            return AttributedString(summary)
        }
    }

    private var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                scoreColor.opacity(0.4),
                scoreColor
            ]),
            startPoint: .trailing,
            endPoint: .leading
        )
    }

    var body: some View {
        VStack(spacing: 13) {
            SemiCircleGauge(
                score: score,
                size: gaugeSize,
                lineWidth: gaugeSize * 0.11,
                gradient: gradient,
                color: scoreColor
            )

            Text(HealthScoreUtilities.getScoreTitle(from: score))
//                .font(Font.satoshiFont(size: 21, weight: .bold, relativeTo: .body))
                .font(.system(size: 21))
                .foregroundColor(titleColor)
                .padding(.top, 8)

            if !summary.isEmpty {
                Text(formattedSummary)
//                    .font(Font.satoshiFont(size: 14, weight: .bold, relativeTo: .body))
                    .font(.system(size: 14))
                    .foregroundColor(summaryColor.opacity(0.8))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
            }
        }
        .padding(EdgeInsets(top: 17, leading: 10, bottom: 10, trailing: 10))
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [backgroundColor.opacity(0.0), backgroundColor.opacity(0.05), backgroundColor.opacity(0.15), backgroundColor.opacity(0.25)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(scoreColor.opacity(0.3), lineWidth: 1)
        )
    }
}

struct SemiCircleGauge: View {
    let score: Int
    let size: CGFloat
    let lineWidth: CGFloat
    let gradient: LinearGradient
    let color: Color

    var body: some View {
        ZStack(alignment: .bottom) {
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(
                    gradient,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(180))
                .frame(width: size, height: size)
                .frame(height: size / 2, alignment: .top)

            Text("\(score)")
                .font(.system(size: size * 0.28, weight: .semibold))
                .foregroundColor(color)
                .offset(y: size * 0.05)
        }
        .frame(width: size, height: size / 2)
    }
}

#Preview {
    VStack {
        OverallHealthCircularScoreView(
            score: 82,
            summary: """
            Your health score shows **good stability**!
            
            ### Highlights:
            - _Strengthening_ physical wellbeing
            - Vital signs within **normal limits**
            
            > Small habits make a big difference.
            """,
            gaugeSize: 120,
            backgroundColor: Color(red: 235/255, green: 249/255, blue: 245/255)
        )
        .padding()
    }
}
