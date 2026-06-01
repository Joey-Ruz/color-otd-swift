import Foundation

extension CategoryDetail {
    /// No forward navigation from CategoryDetail — back-only.
    /// Kept for pattern parity / future use.
    @MainActor
    protocol Router: AnyObject {}
}
