import SwiftUI

enum TabKind: String, CaseIterable, Hashable {
    case today, archive, search, profile
}

/// Minimalist tab-bar icons from ui.jsx.
struct TabIcon: View {
    let kind: TabKind
    let active: Bool
    var size: CGFloat = 24

    private var stroke: Color { active ? CotdColor.ink : CotdColor.inkFaint }
    private var fill: Color { active ? CotdColor.ink : .clear }

    var body: some View {
        TabShape(kind: kind, active: active)
            .stroke(stroke, style: StrokeStyle(lineWidth: 1.7, lineCap: .round, lineJoin: .round))
            .background(
                TabShape(kind: kind, active: active).fill(fill)
            )
            .frame(width: size, height: size)
    }
}

private struct TabShape: Shape {
    let kind: TabKind
    let active: Bool

    func path(in rect: CGRect) -> Path {
        let s = min(rect.width, rect.height) / 24
        var p = Path()

        switch kind {
        case .today:
            // circle cx=12 cy=12 r=7.5 (fill when active)
            p.addEllipse(in: CGRect(x: 4.5 * s, y: 4.5 * s, width: 15 * s, height: 15 * s))

        case .archive:
            // four small squares
            for (x, y) in [(4, 4), (13.5, 4), (4, 13.5), (13.5, 13.5)] {
                p.addRoundedRect(
                    in: CGRect(x: CGFloat(x) * s, y: CGFloat(y) * s, width: 6.5 * s, height: 6.5 * s),
                    cornerSize: CGSize(width: s, height: s)
                )
            }

        case .search:
            // magnifying glass: circle cx=11 cy=11 r=6.5 + handle to (20,20)
            p.addEllipse(in: CGRect(x: 4.5 * s, y: 4.5 * s, width: 13 * s, height: 13 * s))
            p.move(to: CGPoint(x: 16 * s, y: 16 * s))
            p.addLine(to: CGPoint(x: 20 * s, y: 20 * s))

        case .profile:
            // head: circle cx=12 cy=8.5 r=3.7
            p.addEllipse(in: CGRect(x: 8.3 * s, y: 4.8 * s, width: 7.4 * s, height: 7.4 * s))
            // shoulders: M5 20 c0-3.6 3.1-6 7-6 s7 2.4 7 6
            p.move(to: CGPoint(x: 5 * s, y: 20 * s))
            p.addCurve(
                to: CGPoint(x: 12 * s, y: 14 * s),
                control1: CGPoint(x: 5 * s, y: 16.4 * s),
                control2: CGPoint(x: 8.1 * s, y: 14 * s)
            )
            p.addCurve(
                to: CGPoint(x: 19 * s, y: 20 * s),
                control1: CGPoint(x: 15.9 * s, y: 14 * s),
                control2: CGPoint(x: 19 * s, y: 16.4 * s)
            )
        }

        return p
    }
}

#Preview {
    HStack(spacing: Spacing.s24) {
        ForEach(TabKind.allCases, id: \.self) { kind in
            VStack {
                TabIcon(kind: kind, active: true)
                TabIcon(kind: kind, active: false)
            }
        }
    }
    .padding()
    .background(CotdColor.paper)
}
