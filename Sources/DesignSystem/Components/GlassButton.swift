import SwiftUI

/// 40×40 circular icon button with a glass / ultra-thin material backdrop.
/// Two variants:
///   • `.light` — for overlay on a colored hero (white-tinted glass)
///   • `.dark`  — for overlay on paper (paper-tinted glass)
struct GlassButton<Label: View>: View {
    enum Style { case light, dark }
    let style: Style
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    init(
        style: Style = .dark,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.style = style
        self.action = action
        self.label = label
    }

    var body: some View {
        Button(action: action) {
            label()
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, style == .light ? .dark : .light)
                )
                .overlay(
                    Circle().stroke(
                        style == .light
                            ? Color.white.opacity(0.28)
                            : CotdColor.line,
                        lineWidth: 0.5
                    )
                )
        }
        .buttonStyle(.plain)
        .frame(minWidth: HitTarget.minimum, minHeight: HitTarget.minimum)
    }
}

#Preview {
    ZStack {
        Color(hex: 0x003153).ignoresSafeArea()
        HStack(spacing: Spacing.s12) {
            GlassButton(style: .light, action: {}) {
                BackGlyph(color: Color(hex: 0xEDE9DF))
            }
            GlassButton(style: .light, action: {}) {
                HeartGlyph(filled: true, color: Color(hex: 0xEDE9DF))
            }
        }
    }
}
