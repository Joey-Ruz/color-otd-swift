import SwiftUI
import UIKit

/// Static neutral palette per Style Guide.
/// Day-colour + onColor are dynamic and come from the active ColorEntity.
enum CotdColor {
    /// Background — warm off-white paper. #F4F1EA
    static let paper = Color(light: 0xF4F1EA, dark: 0x1A1917)

    /// Card surface on paper — slightly warmer. #FBFAF5
    static let card = Color(light: 0xFBFAF5, dark: 0x232220)

    /// Body text / primary ink. #1C1B18
    static let ink = Color(light: 0x1C1B18, dark: 0xF1EEE7)

    /// Muted secondary text. #75716A
    static let inkMute = Color(light: 0x75716A, dark: 0x9C988F)

    /// Faintest tertiary text / hairline labels. #A9A498
    static let inkFaint = Color(light: 0xA9A498, dark: 0x6B675F)

    /// Standard divider line @ 13% ink.
    static let line = Color(light: 0x1C1B18, dark: 0xF1EEE7).opacity(0.13)

    /// Soft divider line @ 7% ink (between editorial rows).
    static let lineSoft = Color(light: 0x1C1B18, dark: 0xF1EEE7).opacity(0.07)
}

extension Color {
    /// Hex initializer that honors light/dark scheme.
    init(light: UInt32, dark: UInt32) {
        self.init(uiColor: UIColor { trait in
            let value = trait.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red: CGFloat((value >> 16) & 0xFF) / 255.0,
                green: CGFloat((value >> 8) & 0xFF) / 255.0,
                blue: CGFloat(value & 0xFF) / 255.0,
                alpha: 1.0
            )
        })
    }

    /// Hex initializer for a single shade (no dark variant).
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0
        )
    }

    /// Hex string initializer, e.g. "#003153" or "003153".
    init?(hexString: String) {
        var s = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        guard s.count == 6, let value = UInt32(s, radix: 16) else { return nil }
        self.init(hex: value)
    }
}
