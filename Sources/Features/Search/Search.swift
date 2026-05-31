import SwiftUI

/// Search — free-text query + curated theme browse.
enum Search {
    /// A theme resolved with its actual ColorEntity members.
    struct ResolvedTheme: Hashable, Identifiable {
        let id: ThemeId
        let label: String
        let colors: [ColorEntity]
    }
}
