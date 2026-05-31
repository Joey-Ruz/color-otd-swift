import SwiftUI

/// "<" chevron used in glass back buttons.
/// SVG: "M15 4l-8 8 8 8" stroked.
struct BackGlyph: View {
    var color: Color = CotdColor.ink
    var size: CGFloat = 18

    var body: some View {
        BackShape()
            .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .frame(width: size, height: size)
    }
}

private struct BackShape: Shape {
    func path(in rect: CGRect) -> Path {
        let s = min(rect.width, rect.height) / 24
        var p = Path()
        p.move(to: CGPoint(x: 15 * s, y: 4 * s))
        p.addLine(to: CGPoint(x: 7 * s, y: 12 * s))
        p.addLine(to: CGPoint(x: 15 * s, y: 20 * s))
        return p
    }
}

#Preview {
    BackGlyph()
        .padding()
        .background(CotdColor.paper)
}
