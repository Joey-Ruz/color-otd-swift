import Foundation

extension CategoryDetail {
    enum PresenterOutput: Equatable {
        case showLens(ViewModel)
        case showError(MessageType)
    }
}
