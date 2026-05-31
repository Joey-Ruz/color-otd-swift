import SwiftUI

/// Museum-placard label. 11pt Archivo SemiBold, uppercase, 0.18em tracking.
/// Used everywhere we'd otherwise want a small subtle header.
struct SectionLabel: View {
    let text: String
    var color: Color = CotdColor.inkMute

    init(_ text: String, color: Color = CotdColor.inkMute) {
        self.text = text.uppercased()
        self.color = color
    }

    var body: some View {
        Text(text)
            .font(CotdFont.label)
            .tracking(11 * 0.18)
            .foregroundStyle(color)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.s16) {
        SectionLabel("Colour of the Day")
        SectionLabel("Explore through six lenses", color: CotdColor.ink)
    }
    .padding()
    .background(CotdColor.paper)
}
