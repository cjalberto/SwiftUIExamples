//
//  SourceSelectorSheetView.swift
//  Doc App
//
//  Created on 26/01/26.
//

import SwiftUI

public struct SourceSelectorSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let title: String
    private let options: [SourceSelectorOption]
    
    public init(title: String = "Select source", options: [SourceSelectorOption]) {
        self.title = title
        self.options = options
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Title
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.top, 24)
                .padding(.bottom, 32)
            
            // Options container
            VStack(spacing: 0) {
                ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                    Button {
                        option.action()
                        dismiss()
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: option.icon)
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                                .frame(width: 24, height: 24)
                            
                            Text(option.title)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 16)
                        .contentShape(Rectangle())
                    }
                    
                    // White divider line between options
                    if index < options.count - 1 {
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 1)
                            .padding(.horizontal, 15)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white, lineWidth: 1)
            )
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.6))
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.hidden)
    }
}

// MARK: - Preview
#Preview("Source Selector Sheet") {
    Text("Background")
        .sheet(isPresented: .constant(true)) {
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
