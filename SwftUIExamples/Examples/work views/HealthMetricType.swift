import SwiftUI

public enum HealthMetricType: String, CaseIterable, Codable {
    case coreVital = "coreVital"
    case mental = "mental"
    case lifestyle = "lifestyle"
    case metabolic = "metabolic"
    case followUp = "followUp"
    
    public var icon: String {
        switch self {
        case .coreVital: return "icCoreVitals2"
        case .mental: return "icPsychologist2"
        case .lifestyle: return "icLifestyle"
        case .metabolic: return "icEatingHabits"
        case .followUp: return "icFollowUp"
        }
    }
    
    public var tint: Color {
        switch self {
        case .coreVital: return Color(red: 1.0, green: 0.70, blue: 0.70)
        case .mental: return Color(red: 0.60, green: 0.80, blue: 1.0)
        case .lifestyle: return Color.green.opacity(0.55)
        case .metabolic: return Color.orange.opacity(0.6)
        case .followUp: return Color.green.opacity(0.4)
        }
    }
    
    public var mainColor: Color {
        switch self {
        case .coreVital: return .red
        case .mental: return .blue
        case .lifestyle: return .green
        case .metabolic: return .orange
        case .followUp: return Color(red: 0.0, green: 0.67, blue: 0.35)
        }
    }
    
    public var displayTitle: String {
        switch self {
        case .coreVital: return "Core Vital Functions"
        case .mental: return "Mental & Cognitive"
        case .metabolic: return "Metabolic & Nutrition"
        case .lifestyle: return "Lifestyle & Wellness"
        case .followUp: return "Follow Up"
        }
    }
    
    public var displayTitlePrefix: String {
        switch self {
        case .coreVital: return "Core Vital"
        case .mental: return "Mental &"
        case .metabolic: return "Metabolic &"
        case .lifestyle: return "Lifestyle &"
        case .followUp: return "Follow"
        }
    }
    
    public var displayTitleBold: String {
        switch self {
        case .coreVital: return "Functions"
        case .mental: return "Cognitive"
        case .metabolic: return "Nutrition"
        case .lifestyle: return "Wellness"
        case .followUp: return "Up"
        }
    }
    
    public var textColor: Color {
        switch self {
        case .coreVital: return Color(red: 251/255, green: 97/255, blue: 97/255)
        case .mental: return Color(red: 0/255, green: 142/255, blue: 255/255)
        case .metabolic: return Color(red: 255/255, green: 125/255, blue: 41/255)
        case .lifestyle: return Color(red: 85/255, green: 188/255, blue: 168/255)
        case .followUp: return Color(red: 1/255, green: 132/255, blue: 64/255)
        }
    }
    
    public var gradientColors: [Color] {
        switch self {
        case .coreVital: return [mainColor.opacity(0.08), Color.white]
        case .mental: return [mainColor.opacity(0.08), Color.white]
        case .metabolic: return [mainColor.opacity(0.08), Color.white]
        case .lifestyle: return [mainColor.opacity(0.08), Color.white]
        case .followUp: return [mainColor.opacity(0.08), Color.white]
        }
    }
    
    public var widgetTitleWidth: CGFloat {
        switch self {
        case .coreVital: return 62
        case .mental: return 62
        case .metabolic: return 62
        case .lifestyle: return 62
        case .followUp: return 62
        }
    }
}
