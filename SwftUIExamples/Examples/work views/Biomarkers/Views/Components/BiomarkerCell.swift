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
                    limitLowValue: biomarker.limitLowValue,
                    limitHighValue: biomarker.limitHighValue,
                    trend: biomarker.trend
                ),
                style: .compact.with(lineColor: biomarker.statusColor)
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
            unit: "IU/LO",
            category: .biochemicalAnalysis,
            historicalData: Array(dataPoints),
            limitLowValue: 10,
            limitHighValue: 40,
            thresholdVariation: 2.0
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
            unit: "g/dL",
            category: .biochemicalAnalysis,
            historicalData: Array(dataPoints),
            limitLowValue: 3.5,
            limitHighValue: 5.5,
            thresholdVariation: 0.2
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
                unit: "IU/LO",
                category: .biochemicalAnalysis,
                historicalData: makeDataPoints(),
                limitLowValue: 10,
                limitHighValue: 40,
                thresholdVariation: 2.0
            )
        )
        Divider().padding(.horizontal)
        BiomarkerCell(
            biomarker: Biomarker(
                name: "Albúmina\nsuero",
                unit: "g/dL",
                category: .biochemicalAnalysis,
                historicalData: makeDataPoints(),
                limitLowValue: 3.5,
                limitHighValue: 5.5,
                thresholdVariation: 0.2
            )
        )
        Divider().padding(.horizontal)
        BiomarkerCell(
            biomarker: Biomarker(
                name: "Bilirrubina\nIndirecta",
                unit: "mg/dL",
                category: .biochemicalAnalysis,
                historicalData: makeDataPoints(),
                limitLowValue: 0.2,
                limitHighValue: 0.8,
                thresholdVariation: 0.05
            )
        )
    }

}
