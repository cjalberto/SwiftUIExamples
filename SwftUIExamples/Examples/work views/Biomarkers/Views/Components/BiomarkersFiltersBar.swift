//
//  BiomarkersFiltersBar.swift
//  Doc App
//
//  Created on 24/01/26.
//

import SwiftUI

public struct BiomarkersFiltersBar: View {
    @Binding private var searchText: String
    private var onFilterTap: () -> Void
    
    var tintColor: Color = Color(red: 156/255, green: 155/255, blue: 154/255)
    
    public init(searchText: Binding<String>, onFilterTap: @escaping () -> Void = {}) {
        self._searchText = searchText
        self.onFilterTap = onFilterTap
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("FILTERS")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.gray)
            
            HStack(spacing: 13) {
                Button(action: onFilterTap) {
                    HStack(alignment: .center, spacing: 8) {
                        Image("icFilter")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(tintColor)
                            .frame(width: 20, height: 20)
                            .frame(width: 30, height: 30)
                        Text("Filter by")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(tintColor)
                    }
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 20))
                    .padding(.vertical, 7.5)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(tintColor, lineWidth: 0.5)
                    )
                }
                
                // Search field
                SearchFieldView(searchText: $searchText, tintColor: tintColor)
            }
        }
    }
}

// MARK: - Preview
#Preview("Filters Bar") {
    @Previewable @State var search: String = ""
    
    BiomarkersFiltersBar(searchText: $search) {
        print("Filter tapped")
    }
    .padding()

}

#Preview("Filters Bar with Text") {
    @Previewable @State var search: String = "Alanina"
    
    BiomarkersFiltersBar(searchText: $search) {
        print("Filter tapped")
    }
    .padding()

}
