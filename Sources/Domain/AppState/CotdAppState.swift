import Foundation
import Observation

/// App-wide reactive state, singleton per the Flutter pattern.
///
/// Equivalent of `GRAppState.instance` from the Flutter rules.
/// Properties are `@Observable` — SwiftUI views that read them auto-subscribe.
@Observable
@MainActor
final class CotdAppState {
    static let instance = CotdAppState()
    private init() {}

    /// Today's colour, set by the repository on app launch / midnight rollover.
    var todayColor: ColorEntity?

    /// Saved-colour ids. Toggleable from any color view via FavoritesService.
    var favorites: Set<ColorId> = []

    /// How values render across the app. Read by every value placard.
    var displayUnit: ValueUnit = .hex

    /// Whether the daily alert is scheduled.
    var alertEnabled: Bool = true

    /// User-chosen morning alert time. Default 08:00.
    var alertTime: DateComponents = {
        var c = DateComponents()
        c.hour = 8
        c.minute = 0
        return c
    }()

    /// Reset everything that's user-scoped. Called on logout, account deletion.
    func clearForLogOut() {
        todayColor = nil
        favorites = []
        displayUnit = .hex
        alertEnabled = true
        alertTime = {
            var c = DateComponents()
            c.hour = 8
            c.minute = 0
            return c
        }()
    }
}
