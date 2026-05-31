import Foundation

/// Determines which colour is "today's" for a given date.
/// Deterministic from date so all users see the same colour on the same day.
protocol DailyColorService: Sendable {
    /// Returns the ColorId scheduled for `date` (local calendar day).
    func colorId(for date: Date) async -> CotdResult<ColorId>
}
