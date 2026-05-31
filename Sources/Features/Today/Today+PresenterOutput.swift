import Foundation

extension Today {
    /// What the Scene switches on. Sealed for compiler-exhaustive rendering.
    enum PresenterOutput: Equatable {
        case loading
        case showColor(ViewModel)
        case showError(MessageType)

        var isLoading: Bool {
            if case .loading = self { return true }
            return false
        }
    }
}
