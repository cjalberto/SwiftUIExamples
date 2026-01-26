//
//  BiomarkersViewModel.swift
//  Doc App
//
//  Created on 24/01/26.
//

import Foundation
import SwiftUI

// MARK: - Protocol
@MainActor
public protocol BiomarkersViewModelProtocol: ObservableObject {
    var biomarkerGroups: [BiomarkerGroup] { get }
    var searchText: String { get set }
    var isLoading: Bool { get }
    var filteredGroups: [BiomarkerGroup] { get }
    
    func loadBiomarkers() async
}

// MARK: - ViewModel
@MainActor
public final class BiomarkersViewModel: BiomarkersViewModelProtocol {
    @Published public var biomarkerGroups: [BiomarkerGroup] = []
    @Published public var searchText: String = ""
    @Published public var isLoading: Bool = false
    
    public init() {}
    
    public var filteredGroups: [BiomarkerGroup] {
        guard !searchText.isEmpty else { return biomarkerGroups }
        
        return biomarkerGroups.compactMap { group in
            let filtered = group.biomarkers.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
            return filtered.isEmpty ? nil : BiomarkerGroup(category: group.category, biomarkers: filtered)
        }
    }
    
    public func loadBiomarkers() async {
        isLoading = true
        
        // Simulating network delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Mock data
        biomarkerGroups = Self.generateMockData()
        isLoading = false
    }
    
    // MARK: - Mock Data Generator
    static func generateMockData() -> [BiomarkerGroup] {
        let calendar = Calendar.current
        let today = Date()
        
        func historicalData(baseValue: Double, variance: Double) -> [BiomarkerDataPoint] {
            (0..<8).map { dayOffset in
                let date = calendar.date(byAdding: .day, value: -dayOffset * 7, to: today) ?? today
                let randomVariance = Double.random(in: -variance...variance)
                return BiomarkerDataPoint(value: baseValue + randomVariance, date: date)
            }.reversed()
        }
        
        // Helper to create historical data with a specific last value (for out-of-range demos)
        func historicalDataWithLastValue(baseValue: Double, variance: Double, lastValue: Double) -> [BiomarkerDataPoint] {
            var points = Array((0..<7).map { dayOffset in
                let date = calendar.date(byAdding: .day, value: -(dayOffset + 1) * 7, to: today) ?? today
                let randomVariance = Double.random(in: -variance...variance)
                return BiomarkerDataPoint(value: baseValue + randomVariance, date: date)
            }.reversed())
            
            // Add the last value (most recent)
            points.append(BiomarkerDataPoint(value: lastValue, date: today))
            return points
        }
        
        let biochemicalBiomarkers: [Biomarker] = [
            Biomarker(
                name: "Alanina\naminotransferasa",
                unit: "IU/LO",
                category: .biochemicalAnalysis,
                historicalData: historicalDataWithLastValue(baseValue: 28, variance: 6, lastValue: 46), // OUT OF RANGE (>40)
                limitLowValue: 10,
                limitHighValue: 40,
                thresholdVariation: 2.0
            ),
            Biomarker(
                name: "Albúmina\nsuero",
                unit: "g/dL",
                category: .biochemicalAnalysis,
                historicalData: historicalData(baseValue: 4.3, variance: 0.4), // Within 3.5-5.5 range
                limitLowValue: 3.5,
                limitHighValue: 5.5,
                thresholdVariation: 0.2
            ),
            Biomarker(
                name: "Aspartato amino\nTransferasa",
                unit: "IU/LO",
                category: .biochemicalAnalysis,
                historicalData: historicalData(baseValue: 24, variance: 5), // Within 10-40 range
                limitLowValue: 10,
                limitHighValue: 40,
                thresholdVariation: 2.0
            ),
            Biomarker(
                name: "Bilirrubina\nDirecta",
                unit: "mg/dL",
                category: .biochemicalAnalysis,
                historicalData: historicalDataWithLastValue(baseValue: 0.18, variance: 0.06, lastValue: 0.35), // OUT OF RANGE (>0.3)
                limitLowValue: 0,
                limitHighValue: 0.3,
                thresholdVariation: 0.05
            ),
            Biomarker(
                name: "Bilirrubina\nIndirecta",
                unit: "mg/dL",
                category: .biochemicalAnalysis,
                historicalData: historicalData(baseValue: 0.45, variance: 0.12), // Within 0.2-0.8 range
                limitLowValue: 0.2,
                limitHighValue: 0.8,
                thresholdVariation: 0.05
            ),
            Biomarker(
                name: "Bilirubin\nDelta",
                unit: "g/dL",
                category: .biochemicalAnalysis,
                historicalData: historicalData(baseValue: 3.2, variance: 0.6), // Within 1.0-5.0 range
                limitLowValue: 1.0,
                limitHighValue: 5.0,
                thresholdVariation: 0.3
            ),
            Biomarker(
                name: "Calcio\nSuero",
                unit: "mg/dL",
                category: .biochemicalAnalysis,
                historicalData: historicalData(baseValue: 9.3, variance: 0.4), // Within 8.5-10.2 range
                limitLowValue: 8.5,
                limitHighValue: 10.2,
                thresholdVariation: 0.3
            )
        ]
        
        let hematologyBiomarkers: [Biomarker] = [
            Biomarker(
                name: "Hemoglobin",
                unit: "g/dL",
                category: .hematology,
                historicalData: historicalData(baseValue: 15.2, variance: 0.6), // Within 13.5-17.5 range
                limitLowValue: 13.5,
                limitHighValue: 17.5,
                thresholdVariation: 0.3
            ),
            Biomarker(
                name: "White Blood\nCells",
                unit: "K/uL",
                category: .hematology,
                historicalData: historicalDataWithLastValue(baseValue: 7.2, variance: 1.0, lastValue: 12.1), // OUT OF RANGE (>11.0)
                limitLowValue: 4.5,
                limitHighValue: 11.0,
                thresholdVariation: 0.5
            ),
            Biomarker(
                name: "Platelets",
                unit: "K/uL",
                category: .hematology,
                historicalData: historicalData(baseValue: 260, variance: 30), // Within 150-400 range
                limitLowValue: 150,
                limitHighValue: 400,
                thresholdVariation: 15
            )
        ]
        
        let hormonesBiomarkers: [Biomarker] = [
            Biomarker(
                name: "TSH",
                unit: "mIU/L",
                category: .hormones,
                historicalData: historicalData(baseValue: 2.1, variance: 0.5), // Within 0.4-4.0 range
                limitLowValue: 0.4,
                limitHighValue: 4.0,
                thresholdVariation: 0.2
            ),
            Biomarker(
                name: "Cortisol",
                unit: "mcg/dL",
                category: .hormones,
                historicalData: historicalData(baseValue: 14.0, variance: 3.0), // Within 6-23 range
                limitLowValue: 6,
                limitHighValue: 23,
                thresholdVariation: 2.0
            )
        ]
        
        let lipidProfileBiomarkers: [Biomarker] = [
            Biomarker(
                name: "Ideal\nCholesterol",
                unit: "mg/dL",
                category: .lipidProfile,
                historicalData: historicalData(baseValue: 165, variance: 15), // Within 125-200 range
                limitLowValue: 125,
                limitHighValue: 200,
                thresholdVariation: 5
            ),
            Biomarker(
                name: "LDL\nCholesterol",
                unit: "mg/dL",
                category: .lipidProfile,
                historicalData: historicalDataWithLastValue(baseValue: 85, variance: 12, lastValue: 112), // OUT OF RANGE (>100)
                limitLowValue: 0,
                limitHighValue: 100,
                thresholdVariation: 5
            ),
            Biomarker(
                name: "HDL\nCholesterol",
                unit: "mg/dL",
                category: .lipidProfile,
                historicalData: historicalData(baseValue: 52, variance: 5), // Within 40-60 range
                limitLowValue: 40,
                limitHighValue: 60,
                thresholdVariation: 3
            ),
            Biomarker(
                name: "Triglycerides",
                unit: "mg/dL",
                category: .lipidProfile,
                historicalData: historicalData(baseValue: 120, variance: 18), // Within 0-150 range
                limitLowValue: 0,
                limitHighValue: 150,
                thresholdVariation: 10
            )
        ]
        
        let urinalysisBiomarkers: [Biomarker] = [
            Biomarker(
                name: "pH",
                unit: "",
                category: .urinalysis,
                historicalData: historicalData(baseValue: 6.2, variance: 0.6), // Within 5.0-8.0 range
                limitLowValue: 5.0,
                limitHighValue: 8.0,
                thresholdVariation: 0.3
            ),
            Biomarker(
                name: "Specific\nGravity",
                unit: "",
                category: .urinalysis,
                historicalData: historicalData(baseValue: 1.018, variance: 0.008), // Within 1.002-1.030 range
                limitLowValue: 1.002,
                limitHighValue: 1.030,
                thresholdVariation: 0.003
            )
        ]
        
        return [
            BiomarkerGroup(category: .biochemicalAnalysis, biomarkers: biochemicalBiomarkers),
            BiomarkerGroup(category: .hematology, biomarkers: hematologyBiomarkers),
            BiomarkerGroup(category: .hormones, biomarkers: hormonesBiomarkers),
            BiomarkerGroup(category: .lipidProfile, biomarkers: lipidProfileBiomarkers),
            BiomarkerGroup(category: .urinalysis, biomarkers: urinalysisBiomarkers)
        ]
    }
}

// MARK: - Mock ViewModel for Previews
@MainActor
public final class MockBiomarkersViewModel: BiomarkersViewModelProtocol {
    @Published public var biomarkerGroups: [BiomarkerGroup] = []
    @Published public var searchText: String = ""
    @Published public var isLoading: Bool = false
    
    public init() {
        Task {
            await loadBiomarkers()
        }
    }
    
    public var filteredGroups: [BiomarkerGroup] {
        guard !searchText.isEmpty else { return biomarkerGroups }
        return biomarkerGroups.compactMap { group in
            let filtered = group.biomarkers.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
            return filtered.isEmpty ? nil : BiomarkerGroup(category: group.category, biomarkers: filtered)
        }
    }
    
    public func loadBiomarkers() async {
        biomarkerGroups = BiomarkersViewModel.generateMockData()
    }
}
