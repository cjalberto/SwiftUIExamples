//
//  BiomarkersFilterSheet.swift
//  Doc App
//
//  Created on 27/01/26.
//

import SwiftUI

public struct BiomarkersFilterSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCategories: Set<BiomarkerCategory>
    
    private let accentColor: Color = Color(red: 1.0 / 255.0, green: 132.0 / 255.0, blue: 64.0 / 255.0)
    
    public init(selectedCategories: Binding<Set<BiomarkerCategory>>) {
        self._selectedCategories = selectedCategories
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 15) {
                HStack {
                    Text("Filter by:")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(accentColor)
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image("icCloseButton")
                            .resizable()
                            .font(.system(size: 28))
                            .foregroundStyle(accentColor)
                            .frame(width: 30, height: 30)
                    }
                    
                    
                }
                
                Divider()
                    .background(Color(white: 151.0 / 255.0))
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
            
            // Category section
            VStack(alignment: .leading, spacing: 0) {
                Text("CATEGORY")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color(red: 1.0 / 255.0, green: 132.0 / 255.0, blue: 64.0 / 255.0))
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                
                // Category checkboxes
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(BiomarkerCategory.allCases, id: \.self) { category in
                            CategoryCheckboxRow(
                                category: category,
                                isSelected: selectedCategories.contains(category),
                                accentColor: accentColor
                            ) {
                                toggleCategory(category)
                            }
                        }
                    }
                    .padding(.top, 0.5)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Done button
            Button {
                dismiss()
            } label: {
                Text("DONE")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(accentColor)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(Color.white)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
    
    private func toggleCategory(_ category: BiomarkerCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}

// MARK: - Category Checkbox Row
private struct CategoryCheckboxRow: View {
    let category: BiomarkerCategory
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(red: 21.0 / 255.0, green: 74.0 / 255.0, blue: 62.0 / 255.0), lineWidth: 1)
                        .frame(width: 22, height: 22)
                    
                    if isSelected {
                        Image("icCheckMarkChecked")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(Color(red: 1.0 / 255.0, green: 132.0 / 255.0, blue: 64.0 / 255.0))
                            .frame(width: 14, height: 14)
                    }
                }
                
                Text(category.rawValue)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color(red: 21.0 / 255.0, green: 74.0 / 255.0, blue: 62.0 / 255.0))
                
                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.leading, 0.5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview("Biomarkers Filter Sheet") {
    Text("Background")
        .sheet(isPresented: .constant(true)) {
            BiomarkersFilterSheet(
                selectedCategories: .constant([.biochemicalAnalysis, .hematology])
            )
        }
}
