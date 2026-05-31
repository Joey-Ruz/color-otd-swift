import Foundation

extension ColorDetail {
    struct ViewModel: Equatable {
        let color: ColorEntity
        let isFavorite: Bool
        let displayUnit: ValueUnit
    }
}
