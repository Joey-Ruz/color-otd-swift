import Foundation

/// One editorial entry inside a lens — image placeholder, meta caption, title, blurb.
struct LensEntryEntity: Hashable, Identifiable {
    /// Composite id (lens + index) for SwiftUI ForEach.
    var id: String { "\(lensId.rawValue)-\(index)" }
    let lensId: LensId
    let index: Int
    /// Short uppercase byline e.g. "Katsushika Hokusai · c. 1831".
    let meta: String
    /// Serif title.
    let title: String
    /// Body prose — short essay paragraph.
    let blurb: String
    /// Label used in StripePlaceholder, or eventually an asset/URL ref.
    let imageRef: String
}
