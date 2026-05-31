import Foundation

/// Manager-equivalent contract for user-scoped settings.
/// Mutates CotdAppState.* properties — views observe those directly.
@MainActor
protocol SettingsService {
    /// Load persisted settings at app launch.
    func load() async -> CotdResult<Void>

    func setDisplayUnit(_ unit: ValueUnit) async -> CotdResult<Void>
    func setAlertEnabled(_ enabled: Bool) async -> CotdResult<Void>
    func setAlertTime(_ time: DateComponents) async -> CotdResult<Void>
}
