import SwiftUI

/// Derives on-color tints from a base ColorEntity.
/// Used wherever a faint background or hairline tinted to the day-colour is needed
/// (e.g. lens-icon wells in the Today index).
enum ThemeProvider {
    /// 10% tint of the day-colour over paper. Used for lens icon wells.
    static func tint10(_ color: ColorEntity) -> Color {
        color.color.opacity(0.10)
    }

    /// 6% tint. Used for soft hairlines and tinted card edges.
    static func tint06(_ color: ColorEntity) -> Color {
        color.color.opacity(0.06)
    }
}
