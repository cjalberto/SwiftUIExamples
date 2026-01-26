//
//  HealthScoreUtilities.swift
//  SwiftUIExamplesComponents
//
//  Created by Carlos Jaramillo on 12/22/25.
//

import SwiftUI

/// Utility functions for health score calculations and formatting
struct HealthScoreUtilities {
    
    /// Returns the score range label based on the wellness score
    /// - Parameter score: The wellness score (0-100)
    /// - Returns: A string representing the score range (e.g., "Level 71 - 85")
    static func getScoreRange(from score: Int) -> String {
        switch score {
        case 0...50: return "Level 0 - 50"
        case 51...70: return "Level 51 - 70"
        case 71...85: return "Level 71 - 85"
        case 86...95: return "Level 86 - 95"
        case 96...100: return "Level 96 - 100"
        default: return "Level 0 - 50"
        }
    }
    
    /// Returns the score title/category based on the wellness score
    /// - Parameter score: The wellness score (0-100)
    /// - Returns: A string representing the score category (e.g., "Balance Keeper")
    static func getScoreTitle(from score: Int) -> String {
        switch score {
        case 0...50: return "Start Building"
        case 51...70: return "Getting Stronger"
        case 71...85: return "Balance Keeper"
        case 86...95: return "High Performance"
        case 96...100: return "Elite"
        default: return ""
        }
    }
    
    /// Returns the color associated with the wellness score
    /// - Parameter score: The wellness score (0-100)
    /// - Returns: A Color representing the score status
    static func getScoreColor(from score: Int) -> Color {
        switch score {
        case 0...50:
            return Color(red: 255/255, green: 111/255, blue: 97/255) // Coral/Red
        case 51...70:
            return Color(red: 255/255, green: 184/255, blue: 77/255) // Orange
        case 71...85:
            return Color(red: 75/255, green: 184/255, blue: 155/255) // Teal
        case 86...95:
            return Color(red: 75/255, green: 184/255, blue: 155/255) // Teal (High Performance)
        case 96...100:
            return Color(red: 75/255, green: 184/255, blue: 155/255) // Teal (Elite)
        default:
            return Color(red: 255/255, green: 111/255, blue: 97/255)
        }
    }
}
