import Foundation
import Observation

extension Search {
    @MainActor
    @Observable
    final class UseCase {
        private let colorRepo: ColorRepository
        private var allColors: [ColorEntity] = []
        private var resolvedThemes: [Search.ResolvedTheme] = []

        private(set) var output: UseCaseOutput = .loading

        init(colorRepo: ColorRepository) {
            self.colorRepo = colorRepo
        }

        /// Initial load: fetch archive + themes, render browse state.
        func eventLoad() async {
            output = .loading

            async let archiveResult = colorRepo.archive()
            async let themesResult = colorRepo.themes()
            let (archive, themes) = await (archiveResult, themesResult)

            switch (archive, themes) {
            case (.success(let colors), .success(let themes)):
                self.allColors = colors
                self.resolvedThemes = themes.compactMap { theme in
                    let resolved = theme.colorIds.compactMap { id in
                        colors.first { $0.id == id }
                    }
                    guard !resolved.isEmpty else { return nil }
                    return Search.ResolvedTheme(id: theme.id, label: theme.label, colors: resolved)
                }
                output = .presentBrowse(resolvedThemes)
            case (.networkIssue, _), (_, .networkIssue):
                output = .presentError(.networkIssue)
            default:
                output = .presentError(.genericFailure)
            }
        }

        /// Re-emit output based on current query.
        /// Memory impl: instant filter over `allColors`.
        func eventQueryChanged(_ query: String) async {
            let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if trimmed.isEmpty {
                output = .presentBrowse(resolvedThemes)
            } else {
                let matches = allColors.filter { color in
                    color.name.lowercased().contains(trimmed)
                        || color.hex.lowercased().contains(trimmed)
                }
                output = .presentResults(query: query, colors: matches)
            }
        }
    }
}
