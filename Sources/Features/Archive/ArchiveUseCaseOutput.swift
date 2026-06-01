import Foundation

extension Archive {
    enum UseCaseOutput: Equatable {
        case loading
        case presentArchive([ColorEntity])
        case presentError(MessageType)
    }
}
