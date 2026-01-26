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
        
        let biochemicalBiomarkers: [Biomarker] = [
            Biomarker(
                name: "Alanina\naminotransferasa",
                value: 48.0,
                unit: "IU/LO",
                date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 20)) ?? today,
                trend: .up,
                category: .biochemicalAnalysis,
                historicalData: historicalData(baseValue: 45, variance: 10),
                visibleMin: 0,
                visibleMax: 100
            ),
            Biomarker(
                name: "Albúmina\nsuero",
                value: 4.2,
                unit: "g/dL",
                date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 20)) ?? today,
                trend: .down,
                category: .biochemicalAnalysis,
                historicalData: historicalData(baseValue: 4.0, variance: 0.5),
                visibleMin: 0,
                visibleMax: 6
            ),
            Biomarker(
                name: "Aspartato amino\nTransferasa",
                value: 27.0,
                unit: "IU/LO",
                date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 20)) ?? today,
                trend: .up,
                category: .biochemicalAnalysis,
                historicalData: historicalData(baseValue: 25, variance: 5),
                visibleMin: 0,
                visibleMax: 60
            ),
            Biomarker(
                name: "Bilirrubina\nDirecta",
                value: 0.3,
                unit: "mg/dL",
                date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 20)) ?? today,
                trend: .down,
                category: .biochemicalAnalysis,
                historicalData: historicalData(baseValue: 0.4, variance: 0.1),
                visibleMin: 0,
                visibleMax: 1.0
            ),
            Biomarker(
                name: "Bilirrubina\nIndirecta",
                value: 0.2,
                unit: "mg/dL",
                date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 20)) ?? today,
                trend: .neutral,
                category: .biochemicalAnalysis,
                historicalData: historicalData(baseValue: 0.2, variance: 0.05),
                visibleMin: 0,
                visibleMax: 1.0
            ),
            Biomarker(
                name: "Bilirubin\nDelta",
                value: 4.2,
                unit: "g/dL",
                date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 20)) ?? today,
                trend: .down,
                category: .biochemicalAnalysis,
                historicalData: historicalData(baseValue: 4.5, variance: 0.8),
                visibleMin: 0,
                visibleMax: 10.0
            ),
            Biomarker(
                name: "Calcio\nSuero",
                value: 9.1,
                unit: "mg/dL",
                date: calendar.date(from: DateComponents(year: 2025, month: 9, day: 20)) ?? today,
                trend: .down,
                category: .biochemicalAnalysis,
                historicalData: historicalData(baseValue: 9.5, variance: 1.0),
                visibleMin: 5.0,
                visibleMax: 15.0
            )
        ]
        
        let hematologyBiomarkers: [Biomarker] = [
            Biomarker(
                name: "Hemoglobin",
                value: 14.5,
                unit: "g/dL",
                date: today,
                trend: .neutral,
                category: .hematology,
                historicalData: historicalData(baseValue: 14.5, variance: 0.5),
                visibleMin: 10,
                visibleMax: 18
            ),
            Biomarker(
                name: "White Blood\nCells",
                value: 6.5,
                unit: "K/uL",
                date: today,
                trend: .up,
                category: .hematology,
                historicalData: historicalData(baseValue: 6.0, variance: 1.0),
                visibleMin: 3,
                visibleMax: 12
            ),
            Biomarker(
                name: "Platelets",
                value: 250,
                unit: "K/uL",
                date: today,
                trend: .down,
                category: .hematology,
                historicalData: historicalData(baseValue: 260, variance: 20),
                visibleMin: 100,
                visibleMax: 450
            )
        ]
        
        let hormonesBiomarkers: [Biomarker] = [
            Biomarker(
                name: "TSH",
                value: 2.5,
                unit: "mIU/L",
                date: today,
                trend: .neutral,
                category: .hormones,
                historicalData: historicalData(baseValue: 2.5, variance: 0.2),
                visibleMin: 0,
                visibleMax: 5
            ),
            Biomarker(
                name: "Cortisol",
                value: 15.0,
                unit: "mcg/dL",
                date: today,
                trend: .up,
                category: .hormones,
                historicalData: historicalData(baseValue: 12.0, variance: 4.0),
                visibleMin: 0,
                visibleMax: 25
            )
        ]
        
        let lipidProfileBiomarkers: [Biomarker] = [
            Biomarker(
                name: "Ideal\nCholesterol",
                value: 180,
                unit: "mg/dL",
                date: today,
                trend: .down,
                category: .lipidProfile,
                historicalData: historicalData(baseValue: 190, variance: 10),
                visibleMin: 100,
                visibleMax: 250
            ),
            Biomarker(
                name: "LDL\nCholesterol",
                value: 110,
                unit: "mg/dL",
                date: today,
                trend: .down,
                category: .lipidProfile,
                historicalData: historicalData(baseValue: 120, variance: 8),
                visibleMin: 50,
                visibleMax: 160
            ),
            Biomarker(
                name: "HDL\nCholesterol",
                value: 55,
                unit: "mg/dL",
                date: today,
                trend: .up,
                category: .lipidProfile,
                historicalData: historicalData(baseValue: 50, variance: 5),
                visibleMin: 20,
                visibleMax: 80
            ),
            Biomarker(
                name: "Triglycerides",
                value: 140,
                unit: "mg/dL",
                date: today,
                trend: .neutral,
                category: .lipidProfile,
                historicalData: historicalData(baseValue: 140, variance: 15),
                visibleMin: 50,
                visibleMax: 200
            )
        ]
        
        let urinalysisBiomarkers: [Biomarker] = [
            Biomarker(
                name: "pH",
                value: 6.0,
                unit: "",
                date: today,
                trend: .neutral,
                category: .urinalysis,
                historicalData: historicalData(baseValue: 6.0, variance: 0.5),
                visibleMin: 4,
                visibleMax: 9
            ),
            Biomarker(
                name: "Specific\nGravity",
                value: 1.015,
                unit: "",
                date: today,
                trend: .neutral,
                category: .urinalysis,
                historicalData: historicalData(baseValue: 1.015, variance: 0.005),
                visibleMin: 1.000,
                visibleMax: 1.030
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
