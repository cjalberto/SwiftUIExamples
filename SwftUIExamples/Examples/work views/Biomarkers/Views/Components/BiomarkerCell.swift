//
//  BiomarkerCell.swift
//  Doc App
//
//  Created on 24/01/26.
//

import SwiftUI

public struct BiomarkerCell: View {

    
    private let biomarker: Biomarker
    
    public init(biomarker: Biomarker) {
        self.biomarker = biomarker
    }
    
    public var body: some View {
        HStack(spacing: 20) {
            // Left: Biomarker name
            Text(biomarker.name)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color(red: 21.0 / 255.0, green: 74.0 / 255.0, blue: 62.0 / 255.0))
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Center: Mini chart
            BiomarkerMiniChartView(
                data: BiomarkerChartData(
                    dataPoints: biomarker.historicalData,
                    visibleMin: biomarker.visibleMin,
                    visibleMax: biomarker.visibleMax,
                    trend: biomarker.trend
                ),
                style: .compact.with(lineColor: biomarker.trend.color)
            )
            .frame(width: 100, height: 43)
            
            // Right: Value with trend
            BiomarkerValueView(biomarker: biomarker)
                .frame(width: 92)
        }
    }
}

// MARK: - Preview
#Preview("Biomarker Cell - Up Trend") {
    let calendar = Calendar.current
    let today = Date()
    let dataPoints = (0..<8).map { i in
        BiomarkerDataPoint(
            value: Double.random(in: 40...55),
            date: calendar.date(byAdding: .day, value: -i * 7, to: today) ?? today
        )
    }.reversed()
    
    return BiomarkerCell(
        biomarker: Biomarker(
            name: "Alanina\naminotransferasa",
            value: 48.0,
            unit: "IU/LO",
            date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 20)) ?? today,
            trend: .up,
            category: .biochemicalAnalysis,
            historicalData: Array(dataPoints)
        )
    )

}

#Preview("Biomarker Cell - Down Trend") {
    let calendar = Calendar.current
    let today = Date()
    let dataPoints = (0..<8).map { i in
        BiomarkerDataPoint(
            value: Double.random(in: 3.5...4.5),
            date: calendar.date(byAdding: .day, value: -i * 7, to: today) ?? today
        )
    }.reversed()
    
    return BiomarkerCell(
        biomarker: Biomarker(
            name: "Albúmina\nsuero",
            value: 4.2,
            unit: "g/dL",
            date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 20)) ?? today,
            trend: .down,
            category: .biochemicalAnalysis,
            historicalData: Array(dataPoints)
        )
    )

}

#Preview("Multiple Cells") {
    let calendar = Calendar.current
    let today = Date()
    
    func makeDataPoints() -> [BiomarkerDataPoint] {
        Array((0..<8).map { i in
            BiomarkerDataPoint(
                value: Double.random(in: 20...80),
                date: calendar.date(byAdding: .day, value: -i * 7, to: today) ?? today
            )
        }.reversed())
    }
    
    return VStack(spacing: 0) {
        BiomarkerCell(
            biomarker: Biomarker(
                name: "Alanina\naminotransferasa",
                value: 48.0,
                unit: "IU/LO",
                date: today,
                trend: .up,
                category: .biochemicalAnalysis,
                historicalData: makeDataPoints()
            )
        )
        Divider().padding(.horizontal)
        BiomarkerCell(
            biomarker: Biomarker(
                name: "Albúmina\nsuero",
                value: 4.2,
                unit: "g/dL",
                date: today,
                trend: .down,
                category: .biochemicalAnalysis,
                historicalData: makeDataPoints()
            )
        )
        Divider().padding(.horizontal)
        BiomarkerCell(
            biomarker: Biomarker(
                name: "Bilirrubina\nIndirecta",
                value: 0.2,
                unit: "mg/dL",
                date: today,
                trend: .neutral,
                category: .biochemicalAnalysis,
                historicalData: makeDataPoints()
            )
        )
    }

}
