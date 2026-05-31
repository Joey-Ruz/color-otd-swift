import SwiftUI

/// Heart icon — outline by default, fill = filled.
/// SVG: "M12 20S4 14.5 4 9a4 4 0 017.5-2A4 4 0 0120 9c0 5.5-8 11-8 11z"
struct HeartGlyph: View {
    var filled: Bool = false
    var color: Color = CotdColor.ink
    var size: CGFloat = 19

    var body: some View {
        HeartShape()
            .stroke(color, style: StrokeStyle(lineWidth: 1.7, lineJoin: .round))
            .background(
                Group {
                    if filled {
                        HeartShape().fill(color)
                    }
                }
            )
            .frame(width: size, height: size)
    }
}

private struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        let s = min(rect.width, rect.height) / 24
        var p = Path()
        // M12 20
        p.move(to: CGPoint(x: 12 * s, y: 20 * s))
        // S4 14.5 4 9  (smooth cubic — reflected control 1 mirrors prior c2; here, start, no prior, so c1 = start)
        // Approximation: cubic from (12,20) to (4,9), controlling toward (4, 14.5)
        p.addCurve(
            to: CGPoint(x: 4 * s, y: 9 * s),
            control1: CGPoint(x: 4 * s, y: 14.5 * s),
            control2: CGPoint(x: 4 * s, y: 14.5 * s)
        )
        // a4 4 0 017.5-2  → cubic-ish arc from (4,9) to (11.5,7) approximating a 4-radius arc
        p.addCurve(
            to: CGPoint(x: 11.5 * s, y: 7 * s),
            control1: CGPoint(x: 4 * s, y: 6.8 * s),
            control2: CGPoint(x: 7.5 * s, y: 5 * s)
        )
        // A4 4 0 0120 9 → arc to (20,9)
        p.addCurve(
            to: CGPoint(x: 20 * s, y: 9 * s),
            control1: CGPoint(x: 14.5 * s, y: 5 * s),
            control2: CGPoint(x: 20 * s, y: 6.8 * s)
        )
        // c0 5.5-8 11-8 11 → curve back to (12,20)
        p.addCurve(
            to: CGPoint(x: 12 * s, y: 20 * s),
            control1: CGPoint(x: 20 * s, y: 14.5 * s),
            control2: CGPoint(x: 12 * s, y: 20 * s)
        )
        p.closeSubpath()
        return p
    }
}

#Preview {
    HStack(spacing: Spacing.s24) {
        HeartGlyph(filled: false)
        HeartGlyph(filled: true)
        HeartGlyph(filled: true, color: .red, size: 32)
    }
    .padding()
    .background(CotdColor.paper)
}
