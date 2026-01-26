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
