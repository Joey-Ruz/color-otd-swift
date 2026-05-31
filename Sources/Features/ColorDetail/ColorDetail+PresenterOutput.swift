import Foundation

extension ColorDetail {
    enum PresenterOutput: Equatable {
        case showColor(ViewModel)
        case showError(MessageType)
    }
}
