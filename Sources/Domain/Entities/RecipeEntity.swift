import Foundation

/// "How to make this colour" — plain-language description + mix of constituent hues.
/// Accessibility aid: gives colour-blind users named hues to associate.
struct RecipeEntity: Hashable {
    /// Plain-language colour description, e.g. "A very dark blue…".
    let note: String
    /// Constituent hues, ordered.
    let mix: [RecipeMixEntity]

    /// Sum of `parts` across all mix entries — useful for percentage display.
    var totalParts: Int { mix.reduce(0) { $0 + $1.parts } }
}

/// A single constituent colour in a recipe.
struct RecipeMixEntity: Hashable, Identifiable {
    var id: String { "\(name)-\(hex)" }
    let name: String
    let hex: String
    /// Relative proportion; rendered as `parts / totalParts` percentage.
    let parts: Int
}
