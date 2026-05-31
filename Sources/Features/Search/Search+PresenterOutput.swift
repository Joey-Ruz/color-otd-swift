import Foundation

extension Search {
    enum PresenterOutput: Equatable {
        case loading
        case showBrowse(BrowseViewModel)
        case showResults(ResultsViewModel)
        case showError(MessageType)

        var isLoading: Bool {
            if case .loading = self { return true }
            return false
        }
    }
}
