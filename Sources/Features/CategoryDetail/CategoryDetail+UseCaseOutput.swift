import Foundation

extension CategoryDetail {
    enum UseCaseOutput: Equatable {
        case presentLens(color: ColorEntity, lens: LensEntity)
        case presentError(MessageType)
    }
}
