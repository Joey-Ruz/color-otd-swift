import SwiftUI

/// Shared scroll content rendering a Color's hero + values + poem + recipe + lens index.
/// Used by both Today and ColorDetail.
///
/// • `topLabel` differs ("Colour of the Day" vs "Archive Entry")
/// • `onBack` is nil when no back button should render (Today, the tab root)
struct ColorHeroLayout: View {
    let topLabel: String
    let color: ColorEntity
    let isFavorite: Bool
    let displayUnit: ValueUnit
    let onToggleFavorite: () -> Void
    let onOpenLens: (LensId) -> Void
    var onBack: (() -> Void)? = nil
    /// Optional — provided only by Today to allow replaying the launch animation.
    var onReplay: (() -> Void)? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                heroField
                if let recipe = color.recipe {
                    ColorRecipeView(recipe: recipe)
                        .padding(.horizontal, Spacing.gutter)
                        .padding(.top, Spacing.s34)
                        .padding(.bottom, Spacing.s8)
                }
                lensIndex
            }
        }
        .scrollIndicators(.hidden)
    }

    private var heroField: some View {
        VStack(spacing: 0) {
            // top controls
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 7) {
                    Text(topLabel.uppercased())
                        .font(CotdFont.mastheadLabel)
                        .tracking(11 * 0.16)
                        .foregroundStyle(color.onColor.opacity(0.62))
                    Text(color.date)
                        .font(CotdFont.metadata)
                        .tracking(13.5 * 0.03)
                        .foregroundStyle(color.onColor.opacity(0.85))
                }
                Spacer()
                HStack(spacing: 9) {
                    if let onBack {
                        GlassButton(style: .light, action: onBack) {
                            BackGlyph(color: color.onColor)
                        }
                    }
                    if let onReplay {
                        GlassButton(style: .light, action: onReplay) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(color.onColor)
                        }
                    }
                    GlassButton(style: .light, action: onToggleFavorite) {
                        HeartGlyph(filled: isFavorite, color: color.onColor)
                    }
                }
            }
            .padding(.top, Spacing.s64 + 6)
            .padding(.horizontal, Spacing.gutter)

            Spacer(minLength: Spacing.s48)

            // name + values + poem
            VStack(alignment: .leading, spacing: 0) {
                Text(color.name)
                    .font(CotdFont.displayMedium)
                    .tracking(54 * -0.015)
                    .foregroundStyle(color.onColor)
                    .lineSpacing(0)

                HStack(spacing: 22) {
                    ValuePlacard(label: "HEX", value: color.hex.uppercased(), onColor: color.onColor)
                    let r = color.rgb
                    ValuePlacard(label: "RGB", value: "\(r.r)  \(r.g)  \(r.b)", onColor: color.onColor)
                    let h = color.hsl
                    ValuePlacard(label: "HSL", value: "\(h.h)  \(h.s)  \(h.l)", onColor: color.onColor)
                }
                .padding(.top, Spacing.s22)

                if let poem = color.poem {
                    Text(poem)
                        .font(CotdFont.poem)
                        .foregroundStyle(color.onColor.opacity(0.9))
                        .lineSpacing(4)
                        .padding(.top, Spacing.s24)
                        .frame(maxWidth: 330, alignment: .leading)
                }
            }
            .padding(.horizontal, Spacing.gutter)
            .padding(.bottom, Spacing.s30)
        }
        .frame(maxWidth: .infinity, minHeight: Spacing.heroHeight, alignment: .topLeading)
        .background(color.color)
    }

    private var lensIndex: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionLabel("Explore through six lenses")
            Text("Six ways to see \(color.name.split(separator: " ").first.map(String.init) ?? color.name).")
                .font(CotdFont.titleSmall)
                .foregroundStyle(CotdColor.ink)
                .tracking(27 * -0.01)
                .padding(.top, 8)
                .padding(.bottom, 18)

            VStack(spacing: 0) {
                ForEach(Array(LensId.displayOrder.enumerated()), id: \.element) { idx, lensId in
                    if idx > 0 { Rule() }
                    let lens = color.lens(lensId)
                    LensIndexRow(
                        index: idx,
                        label: lens?.label ?? lensId.defaultLabel,
                        teaser: lens?.entries.first?.title ?? "Three curated entries",
                        glyph: lens?.glyph ?? lensId.defaultGlyph,
                        dayColor: color.color,
                        onTap: { onOpenLens(lensId) }
                    )
                }
            }
        }
        .padding(.horizontal, Spacing.gutter)
        .padding(.top, Spacing.s34)
        .padding(.bottom, Spacing.s130)
    }
}
