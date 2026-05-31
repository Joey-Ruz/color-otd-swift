import Foundation

/// Navigation destinations pushed onto a tab's NavigationStack.
enum CotdDestination: Hashable {
    case colorDetail(ColorEntity)
    case categoryDetail(color: ColorEntity, lensId: LensId)
}
