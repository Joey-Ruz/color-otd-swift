import Foundation

extension Profile {
    enum PresenterOutput: Equatable {
        case loading
        case show(ViewModel)
        case showError(MessageType)

        var isLoading: Bool {
            if case .loading = self { return true }
            return false
        }
    }
}
