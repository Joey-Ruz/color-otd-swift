import Foundation

extension Today {
    /// Navigation interface — parent implements (typically App root / TabHost).
    @MainActor
    protocol Router: AnyObject {
        func routeToLens(color: ColorEntity, lensId: LensId)
        func routeReplayReveal()
    }
}
