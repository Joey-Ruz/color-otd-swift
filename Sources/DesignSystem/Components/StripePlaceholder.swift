import SwiftUI

/// 45° diagonal stripe placeholder for editorial imagery to be sourced later.
/// Per Style Guide, this is a deliberate design treatment, not a stopgap.
struct StripePlaceholder: View {
    let label: String
    var height: CGFloat = 200
    var light: Bool = false
    var cornerRadius: CGFloat = 3

    private var background: Color {
        light ? Color.white.opacity(0.06) : CotdColor.ink.opacity(0.035)
    }

    private var strokeColor: Color {
        light ? Color.white.opacity(0.16) : CotdColor.ink.opacity(0.10)
    }

    private var labelBackground: Color {
        light ? Color.black.opacity(0.18) : CotdColor.paper.opacity(0.82)
    }

    private var labelColor: Color {
        light ? Color.white.opacity(0.62) : CotdColor.ink.opacity(0.42)
    }

    var body: some View {
        ZStack {
            background

            StripePattern()
                .stroke(strokeColor, lineWidth: 1.4)

            Text(label.uppercased())
                .font(CotdFont.monoMicro)
                .tracking(10 * 0.06)
                .foregroundStyle(labelColor)
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(labelBackground)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .frame(maxWidth: 280)
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

private struct StripePattern: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let spacing: CGFloat = 11
        let diag = sqrt(rect.width * rect.width + rect.height * rect.height)
        var x: CGFloat = -diag
        while x < diag {
            p.move(to: CGPoint(x: x, y: 0))
            p.addLine(to: CGPoint(x: x + diag, y: diag))
            x += spacing
        }
        return p
    }
}

#Preview {
    VStack(spacing: Spacing.s16) {
        StripePlaceholder(label: "Ukiyo-e woodblock print", height: 230)
        StripePlaceholder(label: "Twilight landscape", height: 100, light: true)
            .background(Color(hex: 0x003153))
    }
    .padding()
    .background(CotdColor.paper)
}
