import Foundation

/// In-memory SettingsService that simply mutates `CotdAppState`.
/// A real implementation would persist to UserDefaults / SwiftData / API.
@MainActor
struct MemorySettingsService: SettingsService {
    let state: CotdAppState

    init(state: CotdAppState = .instance) {
        self.state = state
    }

    func load() async -> CotdResult<Void> {
        // Memory impl: defaults are already on CotdAppState init.
        .success(())
    }

    func setDisplayUnit(_ unit: ValueUnit) async -> CotdResult<Void> {
        state.displayUnit = unit
        return .success(())
    }

    func setAlertEnabled(_ enabled: Bool) async -> CotdResult<Void> {
        state.alertEnabled = enabled
        return .success(())
    }

    func setAlertTime(_ time: DateComponents) async -> CotdResult<Void> {
        state.alertTime = time
        return .success(())
    }
}
