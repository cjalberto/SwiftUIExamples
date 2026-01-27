//
//  SourceSelectorOption.swift
//  Doc App
//
//  Created on 26/01/26.
//

import SwiftUI

public struct SourceSelectorOption: Identifiable {
    public let id = UUID()
    public let icon: String
    public let title: String
    public let action: () -> Void
    
    public init(icon: String, title: String, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.action = action
    }
}
