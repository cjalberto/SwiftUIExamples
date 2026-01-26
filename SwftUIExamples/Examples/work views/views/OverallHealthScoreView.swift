//
//  OverallHealthScoreView.swift
//  SwiftUIExamplesComponents
//
//  Created by Carlos Jaramillo on 12/22/25.
//

import SwiftUI



// MARK: - Mock Health Hub Data Manager
class HealthHubDataManager: ObservableObject {
    static let shared = HealthHubDataManager()
    
    @Published var wellnessScore: Double = 92
    @Published var overallSummary: String? =
    """
    Your current health score shows **good stability** with room to _strengthen_ physical and metabolic wellbeing.

    ### Key Insights:
    - **Vital signs** are within normal limits
    - _Small adjustments_ in daily habits can boost your energy
    - Consistency is key for **long-term performance**
    """
    
    private init() {}
}

// MARK: - Main View
struct OverallHealthScoreView: View {
    @Environment(\.theme) private var theme
    @StateObject private var healthHubManager = HealthHubDataManager.shared
    @State private var showOverallSummarySheet = false
    
    let showFullText: Bool
    let showSeeMoreButton: Bool
    var onSeeMore: (() -> Void)?
    
    init(showFullText: Bool = false, showSeeMoreButton: Bool = true, onSeeMore: (() -> Void)? = nil) {
        self.showFullText = showFullText
        self.showSeeMoreButton = showSeeMoreButton
        self.onSeeMore = onSeeMore
    }
    
    private var formattedSummary: AttributedString {
        guard let summary = healthHubManager.overallSummary,
              !summary.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return AttributedString("")
        }

        // Parse full Markdown first
        let attributed: AttributedString
        do {
            let options = AttributedString.MarkdownParsingOptions(interpretedSyntax: .full)
            attributed = try AttributedString(markdown: summary, options: options)
        } catch {
            attributed = AttributedString(summary)
        }

        // If full text is requested, return parsed Markdown as-is
        guard !showFullText else {
            return attributed
        }

        // Truncate safely AFTER parsing
        let plainText = String(attributed.characters)
        if let firstPeriodIndex = plainText.firstIndex(of: ".") {
            let endIndex = plainText.index(after: firstPeriodIndex)
            let truncatedText = String(plainText[..<endIndex])
            return AttributedString(truncatedText)
        }

        return attributed
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if !showFullText {
                Text(HealthScoreUtilities.getScoreTitle(from: Int(healthHubManager.wellnessScore)))
                    .font(.system(size: 21, weight: .bold))
                    .foregroundColor(theme.darkeness)
                    .multilineTextAlignment(.center)
                    .padding(.top, 6)
            }
            
            Text(HealthScoreUtilities.getScoreRange(from: Int(healthHubManager.wellnessScore)))
                .font(.system(size: showFullText ? 21 : 14, weight: .semibold))
                .foregroundColor(showFullText ? theme.darkeness : theme.appSecundary)
                .multilineTextAlignment(.center)
            
            Text(formattedSummary)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(theme.darkeness)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 0)
            
            if showSeeMoreButton {
                // Botón SEE MORE
                Button {
                    if let customAction = onSeeMore {
                        customAction()
                    } else {
                        showOverallSummarySheet = true
                    }
                } label: {
                    Text("SEE MORE")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(theme.appSecundary)
                        .textCase(.uppercase)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                }
                .background(
                    Capsule()
                        .fill(theme.appSecundary.opacity(0.15))
                )
                .padding(.bottom, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 11)
        .padding(.vertical, 20)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 245/255, green: 245/255, blue: 246/255).opacity(0.5),
                    Color(red: 222/255, green: 242/255, blue: 238/255)
                ],
                startPoint: UnitPoint(x: 0, y: 0.23),
                endPoint: UnitPoint(x: 1, y: 1)
            )
        )
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(red: 1/255, green: 132/255, blue: 64/255).opacity(0.5), lineWidth: 0.5)
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        OverallHealthScoreView()
            .padding()
    }
}
