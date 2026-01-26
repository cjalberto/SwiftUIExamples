import SwiftUI

// MARK: - Theme Structure
struct Theme {
    let darkeness: Color = Color(red: 21/255, green: 74/255, blue: 62/255)
    let appSecundary: Color = Color(red: 1/255, green: 132/255, blue: 64/255)
    let textColor: Color = Color(red: 0.1, green: 0.1, blue: 0.1)
}

// MARK: - Theme Environment Key
private struct ThemeKey: EnvironmentKey {
    static let defaultValue = Theme()
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
