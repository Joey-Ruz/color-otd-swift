import SwiftUI

/// Right-pointing chevron used in Profile settings rows.
/// SVG: "M1 1l6 6-6 6" stroked.
struct Chevron: View {
    var color: Color = CotdColor.inkFaint

    var body: some View {
        ChevronShape()
            .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .frame(width: 8, height: 14)
    }
}

private struct ChevronShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let sx = rect.width / 8
        let sy = rect.height / 14
        p.move(to: CGPoint(x: 1 * sx, y: 1 * sy))
        p.addLine(to: CGPoint(x: 7 * sx, y: 7 * sy))
        p.addLine(to: CGPoint(x: 1 * sx, y: 13 * sy))
        return p
    }
}

#Preview {
    Chevron()
        .padding()
        .background(CotdColor.paper)
}
