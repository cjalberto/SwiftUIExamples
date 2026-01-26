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
    public let unit: String
    public let category: BiomarkerCategory
    public let historicalData: [BiomarkerDataPoint]
    public let limitLowValue: Double?
    public let limitHighValue: Double?
    public let thresholdVariation: Double
    
    public var date: Date {
        historicalData.last?.date ?? Date()
    }
    
    public var value: Double {
        historicalData.last?.value ?? 0
    }
    
    public var trend: BiomarkerTrend {
        guard historicalData.count >= 2 else {
            return .neutral
        }
        
        let lastValue = historicalData.last?.value ?? 0
        let previousValue = historicalData[historicalData.count - 2].value
        let difference = lastValue - previousValue
        
        // If the difference is within the threshold, it's neutral
        if abs(difference) <= thresholdVariation {
            return .neutral
        }
        
        return difference > 0 ? .up : .down
    }
    
    public var statusColor: Color {
        guard let low = limitLowValue, let high = limitHighValue else {
            return Color.gray
        }
        
        let isInRange = (low..<high).contains(value)
        let color = isInRange ? Color(red: 1/255, green: 132/255, blue: 64/255) : Color.orange
        
        // Debug output
        print("🔍 \(name): value=\(value), range=[\(low)-\(high)], inRange=\(isInRange), historic=\(historicalData.map{$0.value}), color=\(isInRange ? "GREEN" : "ORANGE")")
        
        return color
    }
    
    public init(
        id: UUID = UUID(),
        name: String,
        unit: String,
        category: BiomarkerCategory,
        historicalData: [BiomarkerDataPoint] = [],
        limitLowValue: Double? = nil,
        limitHighValue: Double? = nil,
        thresholdVariation: Double = 0.0
    ) {
        self.id = id
        self.name = name
        self.unit = unit
        self.category = category
        self.historicalData = historicalData
        self.limitLowValue = limitLowValue
        self.limitHighValue = limitHighValue
        self.thresholdVariation = thresholdVariation
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
