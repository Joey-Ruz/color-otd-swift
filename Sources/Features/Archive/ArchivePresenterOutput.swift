import Foundation

extension Archive {
    enum PresenterOutput: Equatable {
        case loading
        case showArchive(ViewModel)
        case showError(MessageType)

        var isLoading: Bool {
            if case .loading = self { return true }
            return false
        }
    }
}
