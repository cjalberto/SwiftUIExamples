//
//  BiomarkerModels.swift
//  Doc App
//
//  Created on 24/01/26.
//

import SwiftUI

// MARK: - Biomarker Trend
public enum BiomarkerTrend: String, Codable, CaseIterable {
    case up
    case down
    case neutral
    
    var arrow: String {
        switch self {
        case .up: return "↑"
        case .down: return "↓"
        case .neutral: return "—"
        }
    }
    
    var color: Color {
        switch self {
        case .up: return Color.orange
        case .down: return Color(red: 1/255, green: 132/255, blue: 64/255)
        case .neutral: return Color.gray
        }
    }
}

// MARK: - Biomarker Category
public enum BiomarkerCategory: String, Codable, CaseIterable, Identifiable {
    case biochemicalAnalysis = "BIOCHEMICAL ANALYSIS"
    case hematology = "HEMATOLOGY"
    case hormones = "HORMONES"
    case lipidProfile = "LIPID PROFILE"
    case urinalysis = "URINALYSIS"
    
    public var id: String { rawValue }
}

// MARK: - Biomarker Data Point (for mini chart)
public struct BiomarkerDataPoint: Identifiable, Codable {
    public let id: UUID
    public let value: Double
    public let date: Date
    
    public init(id: UUID = UUID(), value: Double, date: Date) {
        self.id = id
        self.value = value
        self.date = date
    }
}

// MARK: - Biomarker Model
public struct Biomarker: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let value: Double
    public let unit: String
    public let date: Date
    public let trend: BiomarkerTrend
    public let category: BiomarkerCategory
    public let historicalData: [BiomarkerDataPoint]
    public let visibleMin: Double?
    public let visibleMax: Double?
    
    public init(
        id: UUID = UUID(),
        name: String,
        value: Double,
        unit: String,
        date: Date,
        trend: BiomarkerTrend,
        category: BiomarkerCategory,
        historicalData: [BiomarkerDataPoint] = [],
        visibleMin: Double? = nil,
        visibleMax: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.value = value
        self.unit = unit
        self.date = date
        self.trend = trend
        self.category = category
        self.historicalData = historicalData
        self.visibleMin = visibleMin
        self.visibleMax = visibleMax
    }
    
    // Formatted value with unit
    public var formattedValue: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return "\(formatter.string(from: NSNumber(value: value)) ?? "\(value)") \(unit)"
    }
    
    // Formatted date string
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date).lowercased()
    }
}

// MARK: - Grouped Biomarkers
public struct BiomarkerGroup: Identifiable {
    public let id: String
    public let category: BiomarkerCategory
    public let biomarkers: [Biomarker]
    
    public init(category: BiomarkerCategory, biomarkers: [Biomarker]) {
        self.id = category.rawValue
        self.category = category
        self.biomarkers = biomarkers
    }
}
