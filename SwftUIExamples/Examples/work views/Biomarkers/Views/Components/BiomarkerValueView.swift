//
//  BiomarkerValueView.swift
//  Doc App
//
//  Created on 24/01/26.
//

import SwiftUI

public struct BiomarkerValueView: View {

    
    private let value: String
    private let trend: BiomarkerTrend
    private let date: String
    private let statusColor: Color
    
    public init(value: String, trend: BiomarkerTrend, date: String, statusColor: Color) {
        self.value = value
        self.trend = trend
        self.date = date
        self.statusColor = statusColor
    }
    
    public init(biomarker: Biomarker) {
        self.value = biomarker.formattedValue
        self.trend = biomarker.trend
        self.date = biomarker.formattedDate
        self.statusColor = biomarker.statusColor
    }
    
    public var body: some View {
        VStack(alignment: .trailing, spacing: 2) {
            HStack(spacing: 4) {
                Text(trend.arrow)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(statusColor)
                
                Text(value)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(statusColor)
            }
            
            Text(date)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.gray.opacity(0.7))
        }
    }
}

// MARK: - Preview
#Preview("Value View - Up Trend") {
    BiomarkerValueView(
        value: "48.0 IU/LO",
        trend: .up,
        date: "20 sep 2025",
        statusColor: .orange
    )
    .padding()
}

#Preview("Value View - Down Trend") {
    BiomarkerValueView(
        value: "4.2 g/dL",
        trend: .down,
        date: "20 sep 2025",
        statusColor: Color(red: 1/255, green: 132/255, blue: 64/255)
    )
    .padding()
}

#Preview("Value View - Neutral") {
    BiomarkerValueView(
        value: "0.2 mg/dL",
        trend: .neutral,
        date: "20 sep 2025",
        statusColor: Color(red: 1/255, green: 132/255, blue: 64/255)
    )
    .padding()
}
