//
//  BiomarkersView.swift
//  Doc App
//
//  Created on 24/01/26.
//

import SwiftUI

public struct BiomarkersView<ViewModel: BiomarkersViewModelProtocol>: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ViewModel
    
    @State private var showFiltersSheet: Bool = false
    @State private var showSourceSelector: Bool = false
    
    private let accentColor: Color
    
    public init(viewModel: ViewModel, accentColor: Color) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.accentColor = accentColor
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // Filters bar
                BiomarkersFiltersBar(
                    searchText: Binding(
                        get: { viewModel.searchText },
                        set: { viewModel.searchText = $0 }
                    ),
                    onFilterTap: {
                        showFiltersSheet = true
                    }
                )
                .padding(.top, 16)
                
                Spacer(minLength: 30)
                
                // Biomarkers list
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 26, pinnedViews: .sectionHeaders) {
                        ForEach(viewModel.filteredGroups) { group in
                            Section {
                                ForEach(group.biomarkers) { biomarker in
                                    BiomarkerCell(biomarker: biomarker)
                                }
                            } header: {
                                sectionHeader(title: group.category.rawValue)
                            }
                        }
                    }
                    .padding(.bottom, 100)
                }
                
                Spacer()
            }
            
            addMoreButton
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarView
        }
        .padding(.horizontal, 20)
        
        .task {
            await viewModel.loadBiomarkers()
        }
        .sheet(isPresented: $showFiltersSheet) {
            BiomarkersFilterSheet(
                selectedCategories: Binding(
                    get: { viewModel.selectedCategories },
                    set: { viewModel.selectedCategories = $0 }
                )
            )
        }
        .sheet(isPresented: $showSourceSelector) {
            SourceSelectorSheetView(
                title: "Select source",
                options: [
                    SourceSelectorOption(icon: "doc", title: "Files") {
                        print("Files selected")
                    },
                    SourceSelectorOption(icon: "photo", title: "Gallery") {
                        print("Gallery selected")
                    },
                    SourceSelectorOption(icon: "camera", title: "Camera") {
                        print("Camera selected")
                    }
                ]
            )
        }
    }
    
    private func sectionHeader(title: String) -> some View {
        Text(title)
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(Color(red: 1.0 / 255.0, green: 132.0 / 255.0, blue: 64.0 / 255.0))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ToolbarContentBuilder
    private var toolbarView: some ToolbarContent {
        if #available(iOS 26.0, *) {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("icNavigationBack")
                        .renderingMode(.template)
                        .foregroundColor(accentColor)
                        .frame(width: 30, height: 30)
                        .contentShape(Rectangle())
                }
            }
            .sharedBackgroundVisibility(.hidden)
            
            ToolbarItem(placement: .principal) {
                Text("Biomarkers")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(accentColor)
            }
        } else {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("icNavigationBack")
                        .renderingMode(.template)
                        .foregroundColor(accentColor)
                        .frame(width: 30, height: 30)
                        .contentShape(Rectangle())
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Biomarkers")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(accentColor)
            }
        }
    }
    
    private var addMoreButton: some View {
        Button {
            showSourceSelector = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18))
                Text("ADD MORE")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(accentColor)
            )
        }
        .padding(.bottom, 20)
    }
}

// MARK: - Typealias
public typealias DefaultBiomarkersView = BiomarkersView<BiomarkersViewModel>

// MARK: - Preview
#Preview("Biomarkers View") {
    NavigationStack {
        BiomarkersView(
            viewModel: MockBiomarkersViewModel(),
            accentColor: Color(red: 0.13, green: 0.55, blue: 0.13)
        )
    }
}

#Preview("Biomarkers View - Loading") {
    NavigationStack {
        BiomarkersView(
            viewModel: BiomarkersViewModel(),
            accentColor: Color(red: 0.13, green: 0.55, blue: 0.13)
        )
    }
}
