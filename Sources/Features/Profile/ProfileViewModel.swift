import Foundation

extension Profile {
    struct ViewModel: Equatable {
        let savedColors: [ColorEntity]
        let displayUnit: ValueUnit
        let alertEnabled: Bool
        let alertTime: DateComponents
    }
}
