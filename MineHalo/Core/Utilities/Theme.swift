import SwiftUI

final class ThemeManager: ObservableObject {
    let primary = Color("Primary", bundle: nil)
    let accent = Color("AccentColor", bundle: nil)
    let bg = Color(.systemGroupedBackground)
}
