import SwiftUI

/// Hairline divider — 1pt at 13% ink (CotdColor.line).
/// Use `Rule(.soft)` for the lighter inter-row separator (7% ink).
struct Rule: View {
    enum Weight { case standard, soft }
    var weight: Weight = .standard

    init(_ weight: Weight = .standard) { self.weight = weight }

    var body: some View {
        Rectangle()
            .fill(weight == .standard ? CotdColor.line : CotdColor.lineSoft)
            .frame(height: 1)
    }
}

#Preview {
    VStack(spacing: 20) {
        Rule()
        Rule(.soft)
    }
    .padding()
    .background(CotdColor.paper)
}
