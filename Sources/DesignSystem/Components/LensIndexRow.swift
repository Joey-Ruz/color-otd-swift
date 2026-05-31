import SwiftUI

/// Single row in the "Explore through six lenses" index on Today / ColorDetail.
/// Index numeral + serif label + teaser + glyph-in-tint-well.
struct LensIndexRow: View {
    let index: Int
    let label: String
    let teaser: String
    let glyph: LensKind
    let dayColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Text(String(format: "%02d", index + 1))
                    .font(CotdFont.monoIndex)
                    .foregroundStyle(CotdColor.inkFaint)
                    .frame(width: 20, alignment: .leading)

                VStack(alignment: .leading, spacing: 4) {
                    Text(label)
                        .font(CotdFont.lensRowTitle)
                        .foregroundStyle(CotdColor.ink)
                        .lineLimit(1)
                    Text(teaser)
                        .font(CotdFont.caption)
                        .foregroundStyle(CotdColor.inkMute)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                ZStack {
                    Circle().fill(dayColor.opacity(0.10))
                        .frame(width: 40, height: 40)
                    LensGlyph(kind: glyph, color: dayColor, size: 20, strokeWidth: 1.5)
                }
            }
            .padding(.vertical, 17)
        }
        .buttonStyle(.plain)
    }
}
