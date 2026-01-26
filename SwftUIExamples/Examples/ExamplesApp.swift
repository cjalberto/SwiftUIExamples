//
//  ExamplesApp.swift
//  estudiando
//
//  Created by Carlos Jaramillo on 10/28/23.
//

import SwiftUI

@main
struct ExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                VStack(spacing: 20) {
                    NavigationLink(destination: BiomarkersView(
                        viewModel: MockBiomarkersViewModel(),
                        accentColor: Color(red: 1.0 / 255.0, green: 132.0 / 255.0, blue: 64.0 / 255.0)
                    )) {
                        Text("Open Biomarkers View")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // BiomarkerMiniChartView with custom values
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Biomarker Mini Chart")
                            .font(.headline)
                        
                        BiomarkerMiniChartView(
                            data: BiomarkerChartData(
                                dataPoints: {
                                    let calendar = Calendar.current
                                    let today = Date()
                                    let values = [0.16563013854880626, 0.23783671914867058, 0.14522232426998896, 0.18596883167120984, 0.15014716885434862, 0.14861950364023305, 0.21701672112913406, 0.35]
                                    
                                    // Map values to dates from oldest to newest
                                    // Index 0 gets the oldest date, last index gets today
                                    return values.enumerated().map { index, value in
                                        BiomarkerDataPoint(
                                            value: value,
                                            date: calendar.date(byAdding: .day, value: -(values.count - 1 - index) * 7, to: today) ?? today
                                        )
                                    }
                                }(),
                                limitLowValue: 0.0,
                                limitHighValue: 0.3,
                                trend: .up
                            ),
                            style: .default
                        )
                        .frame(width: 200, height: 60)
                    }
                    .padding(.horizontal)
                    
                    PillarSummaryCard(
                        title: "Core Vital Functions",
                        icon: "icEatingHabits",
                        color: Color.red,
                        score: 82,
                        summary: "Your Central Vital Functions show a strong foundation, particularly in your cardiovascular health."
                    )
                    
                    PillarSummaryCard(
                        title: "Mental & Cognitive",
                        icon: "icBrain",
                        color: Color.blue,
                        score: 44,
                        summary: "You show strong resilience and low anxiety symptoms, which are great strengths!"
                    )
                    CoreVitalHealthCard(systolic: 50,
                                        diastolic: 10,
                                        restingHeartRate: 20,
                                        summary: "Your Central Vital Functions show a strong foundation, particularly in your cardiovascular health."
                    )
                }
                .padding(10)
                .background(.white)
                .navigationTitle("Examples")
            }
        }
    }
}
