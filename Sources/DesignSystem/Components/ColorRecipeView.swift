import SwiftUI

/// "How to make this colour" — proportion bar + named-hue legend.
/// Accessibility aid: associates the colour with the names of its constituent hues.
struct ColorRecipeView: View {
    let recipe: RecipeEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                SectionLabel("How to make this colour")
                Spacer()
                Text("\(recipe.mix.count) hues")
                    .font(CotdFont.monoSwatch)
                    .foregroundStyle(CotdColor.inkFaint)
            }

            Text(recipe.note)
                .font(CotdFont.recipeNote)
                .foregroundStyle(CotdColor.ink)
                .lineSpacing(2)
                .padding(.top, 9)

            // Proportion bar
            GeometryReader { geo in
                HStack(spacing: 0) {
                    ForEach(recipe.mix) { hue in
                        Rectangle()
                            .fill(Color(hexString: hue.hex) ?? .gray)
                            .frame(width: geo.size.width * CGFloat(hue.parts) / CGFloat(max(recipe.totalParts, 1)))
                    }
                }
            }
            .frame(height: 46)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.tile))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.tile)
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
            )
            .padding(.top, 18)

            // Legend
            VStack(spacing: 0) {
                ForEach(Array(recipe.mix.enumerated()), id: \.element.id) { idx, hue in
                    VStack(spacing: 0) {
                        if idx > 0 { Rule(.soft) }
                        HStack(spacing: 12) {
                            Rectangle()
                                .fill(Color(hexString: hue.hex) ?? .gray)
                                .frame(width: 16, height: 16)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                                )
                            Text(hue.name)
                                .font(.system(size: 14.5))
                                .foregroundStyle(CotdColor.ink)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(hue.hex.uppercased())
                                .font(CotdFont.monoIndex)
                                .foregroundStyle(CotdColor.inkMute)
                            Text("\(percent(for: hue))%")
                                .font(CotdFont.monoIndex)
                                .foregroundStyle(CotdColor.inkFaint)
                                .frame(width: 34, alignment: .trailing)
                        }
                        .padding(.vertical, 11)
                    }
                }
            }
            .padding(.top, 16)

            Rule().padding(.top, 22)
        }
    }

    private func percent(for hue: RecipeMixEntity) -> Int {
        Int(round(Double(hue.parts) / Double(max(recipe.totalParts, 1)) * 100))
    }
}
