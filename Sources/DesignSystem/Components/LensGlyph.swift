import SwiftUI

/// One of six minimal line glyphs for the lenses.
enum LensKind: String, CaseIterable, Hashable {
    case brush      // Art History
    case thread     // Fashion
    case leaf       // Nature
    case star       // Pop Culture
    case quote      // Etymology
    case eye        // Symbolism
}

/// Renders the lens glyph in a 24×24 viewBox, scaled to the given size.
struct LensGlyph: View {
    let kind: LensKind
    var color: Color = CotdColor.ink
    var size: CGFloat = 22
    var strokeWidth: CGFloat = 1.6

    var body: some View {
        LensShape(kind: kind)
            .stroke(color, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
            .frame(width: size, height: size)
    }
}

private struct LensShape: Shape {
    let kind: LensKind

    func path(in rect: CGRect) -> Path {
        let s = min(rect.width, rect.height) / 24
        var p = Path()

        switch kind {
        case .brush:
            // pencil tip: M15 4 l5 5 -8 8 -3 -3 8 -8 z
            p.move(to: pt(15, 4, s))
            p.addLine(to: pt(20, 9, s))
            p.addLine(to: pt(12, 17, s))
            p.addLine(to: pt(9, 14, s))
            p.addLine(to: pt(17, 6, s))
            p.closeSubpath()
            // bristles: M9 14 c-3 0 -4 2 -4 5  3 0 5 -1 5 -4
            p.move(to: pt(9, 14, s))
            p.addCurve(
                to: pt(5, 19, s),
                control1: pt(6, 14, s),
                control2: pt(5, 16, s)
            )
            p.addCurve(
                to: pt(10, 15, s),
                control1: pt(8, 19, s),
                control2: pt(10, 18, s)
            )

        case .thread:
            // spool: circle cx=8 cy=8 r=4
            p.addEllipse(in: CGRect(x: 4 * s, y: 4 * s, width: 8 * s, height: 8 * s))
            // thread: M11 11 L20 20  +  M18 16 L20 20 L24 20.5
            p.move(to: pt(11, 11, s))
            p.addLine(to: pt(20, 20, s))
            p.move(to: pt(18, 16, s))
            p.addLine(to: pt(20, 20, s))
            p.addLine(to: pt(24, 20.5, s))

        case .leaf:
            // outline: M5 19 C5 11 11 5 19 5  c0 8 -6 14 -14 14 z
            p.move(to: pt(5, 19, s))
            p.addCurve(
                to: pt(19, 5, s),
                control1: pt(5, 11, s),
                control2: pt(11, 5, s)
            )
            p.addCurve(
                to: pt(5, 19, s),
                control1: pt(19, 13, s),
                control2: pt(13, 19, s)
            )
            p.closeSubpath()
            // vein: M5 19 C8 14 12 11 16 9
            p.move(to: pt(5, 19, s))
            p.addCurve(
                to: pt(16, 9, s),
                control1: pt(8, 14, s),
                control2: pt(12, 11, s)
            )

        case .star:
            // 10-vertex star
            let pts: [(CGFloat, CGFloat)] = [
                (12, 4), (14.2, 9.2), (20, 10), (16, 13.6), (17.1, 19),
                (12, 16), (6.9, 19), (8, 13.6), (4, 10), (9.8, 9.2)
            ]
            p.move(to: pt(pts[0].0, pts[0].1, s))
            for (x, y) in pts.dropFirst() {
                p.addLine(to: pt(x, y, s))
            }
            p.closeSubpath()

        case .quote:
            // left quote: M9 7 C6 8 5 11 5 15 h4 v-4 H6.5 C7 9 8 8 9.5 7.6 z
            p.move(to: pt(9, 7, s))
            p.addCurve(
                to: pt(5, 15, s),
                control1: pt(6, 8, s),
                control2: pt(5, 11, s)
            )
            p.addLine(to: pt(9, 15, s))   // h4
            p.addLine(to: pt(9, 11, s))   // v-4
            p.addLine(to: pt(6.5, 11, s)) // H6.5
            p.addCurve(
                to: pt(9.5, 7.6, s),
                control1: pt(7, 9, s),
                control2: pt(8, 8, s)
            )
            p.closeSubpath()
            // right quote: M18 7 c-3 1 -4 4 -4 8 h4 v-4 h-2.5 c.5-2 1.5-3 3-3.4 z
            p.move(to: pt(18, 7, s))
            p.addCurve(
                to: pt(14, 15, s),
                control1: pt(15, 8, s),
                control2: pt(14, 11, s)
            )
            p.addLine(to: pt(18, 15, s))   // h4
            p.addLine(to: pt(18, 11, s))   // v-4
            p.addLine(to: pt(15.5, 11, s)) // h-2.5
            p.addCurve(
                to: pt(18.5, 7.6, s),
                control1: pt(16, 9, s),
                control2: pt(17, 8, s)
            )
            p.closeSubpath()

        case .eye:
            // outline: M2 12 s4-7 10-7 10 7 10 7 -4 7 -10 7 S2 12 2 12 z
            // Two arcs approximating an eye almond
            p.move(to: pt(2, 12, s))
            p.addCurve(
                to: pt(12, 5, s),
                control1: pt(2, 5, s),
                control2: pt(6, 5, s)
            )
            p.addCurve(
                to: pt(22, 12, s),
                control1: pt(18, 5, s),
                control2: pt(22, 12, s)
            )
            p.addCurve(
                to: pt(12, 19, s),
                control1: pt(22, 12, s),
                control2: pt(18, 19, s)
            )
            p.addCurve(
                to: pt(2, 12, s),
                control1: pt(6, 19, s),
                control2: pt(2, 12, s)
            )
            p.closeSubpath()
            // iris: circle cx=12 cy=12 r=3
            p.addEllipse(in: CGRect(x: 9 * s, y: 9 * s, width: 6 * s, height: 6 * s))
        }

        return p
    }

    private func pt(_ x: CGFloat, _ y: CGFloat, _ s: CGFloat) -> CGPoint {
        CGPoint(x: x * s, y: y * s)
    }
}

#Preview {
    HStack(spacing: Spacing.s24) {
        ForEach(LensKind.allCases, id: \.self) { kind in
            VStack(spacing: 6) {
                LensGlyph(kind: kind, size: 28)
                Text(kind.rawValue).font(CotdFont.captionSmall)
            }
        }
    }
    .padding()
    .background(CotdColor.paper)
}
