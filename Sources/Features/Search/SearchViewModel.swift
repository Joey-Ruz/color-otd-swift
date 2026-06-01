import Foundation

extension Search {
    struct BrowseViewModel: Equatable {
        let themes: [ResolvedTheme]
    }

    struct ResultsViewModel: Equatable {
        let query: String
        let colors: [ColorEntity]
    }
}
