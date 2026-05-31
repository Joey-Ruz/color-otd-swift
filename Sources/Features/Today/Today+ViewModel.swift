import Foundation

extension Today {
    /// Thin view model — composes the entity with reactive state the Scene needs
    /// (favorite flag, display unit). Recomposed by the Presenter on every read.
    struct ViewModel: Equatable {
        let color: ColorEntity
        let isFavorite: Bool
        let displayUnit: ValueUnit
    }
}
