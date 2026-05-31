import Foundation

extension Today {
    /// What the UseCase emits. Mapped to PresenterOutput by an extension method.
    enum UseCaseOutput: Equatable {
        case loading
        case presentColor(ColorEntity)
        case presentError(MessageType)
    }
}
