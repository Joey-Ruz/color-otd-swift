import SwiftUI

/// Editorial color tile used in Archive, Profile (saved colors), Search results.
/// Color block + name + hex + date underneath. Optional favorite indicator overlay.
struct SwatchTile: View {
    let name: String
    let hex: String
    let date: String
    let color: Color
    var onColor: Color
    var aspect: CGFloat = 0.86
    var showFavoriteOverlay: Bool = false
    var isFavorite: Bool = false
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Spacing.s9) {
                Rectangle()
                    .fill(color)
                    .aspectRatio(aspect, contentMode: .fit)
                    .overlay(alignment: .topTrailing) {
                        if showFavoriteOverlay {
                            HeartGlyph(filled: isFavorite, color: onColor, size: 16)
                                .padding(9)
                        }
                    }
                    .overlay(
                        Rectangle()
                            .stroke(CotdColor.ink.opacity(0.04), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.tile))

                VStack(alignment: .leading, spacing: 3) {
                    Text(name)
                        .font(CotdFont.swatchName)
                        .foregroundStyle(CotdColor.ink)
                        .lineLimit(1)
                    HStack {
                        Text(hex.uppercased())
                            .font(CotdFont.monoSwatch)
                            .foregroundStyle(CotdColor.inkMute)
                        Spacer()
                        Text(date)
                            .font(CotdFont.monoSwatch)
                            .foregroundStyle(CotdColor.inkFaint)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LazyVGrid(
        columns: [GridItem(.flexible()), GridItem(.flexible())],
        spacing: 26
    ) {
        SwatchTile(
            name: "Prussian Blue",
            hex: "#003153",
            date: "May 28 2026",
            color: Color(hex: 0x003153),
            onColor: Color(hex: 0xEDE9DF)
        )
        SwatchTile(
            name: "Vermilion",
            hex: "#E34234",
            date: "May 27 2026",
            color: Color(hex: 0xE34234),
            onColor: Color(hex: 0x2A0F0B),
            showFavoriteOverlay: true,
            isFavorite: true
        )
    }
    .padding()
    .background(CotdColor.paper)
}
