import SwiftUI

extension Reveal {
    /// Cold-launch reveal — a multi-stage theatrical choreography (~25s total):
    ///
    ///  1. Plain light-paper background (forced light, even in dark mode)
    ///  2. For each pigment (~4.5s each):
    ///       • 0.5s slide in from the left
    ///       • 2.0s hold centered (name + hex)
    ///       • 0.4s shift: name + hex slide to left, percentage fades in on right
    ///       • 0.6s hold in the shifted layout
    ///       • 1.0s morph from strip into a small sphere that joins the swirl
    ///  3. Spheres orbit (~5s) — accelerating, growing to percentage-proportional
    ///     sizes, then collapsing toward centre
    ///  4. Burst + bubble pop (~2s): paint sphere explodes, satellite bubbles pop
    ///  5. Clean pour cascade (~2.5s): paint floods down with subtle depth shading
    ///  6. Whole reveal slides up to expose Today beneath
    ///
    /// All circular elements (strips, droplets, bubbles, explosion) render with
    /// a radial gloss overlay + drop shadow so they read as 3D objects.
    struct Scene: View {
        @State var presenter: Presenter

        // Phase tracking
        @State private var enteredCount: Int = 0
        @State private var currentColorIdx: Int? = nil
        @State private var stripState: StripState = .none
        @State private var swirlStartTime: TimeInterval = 0
        @State private var exploding: Bool = false
        @State private var pouring: Bool = false

        // Animated values
        @State private var orbitRadius: CGFloat = 90
        @State private var percentageScale: CGFloat = 0
        @State private var angularSpeed: Double = 1.2
        @State private var explosionDiameter: CGFloat = 0
        @State private var pourHeight: CGFloat = 0
        @State private var revealOffset: CGFloat = 0
        @State private var bubbleScales: [CGFloat] = Array(repeating: 0, count: 4)

        enum StripState {
            case none, sliding, held, heldShifted, morphing
        }

        // Sub-bubble offsets (x, y, scale, size) relative to swirl centre
        private let bubbleOffsets: [(x: CGFloat, y: CGFloat, scale: CGFloat, size: CGFloat)] = [
            (-90, -20, 1.3, 80),
            (70, -60, 0.9, 70),
            (-50, 60, 1.5, 60),
            (95, 35, 0.8, 90),
        ]

        /// Forced-light paper — Reveal stays bright regardless of system appearance.
        private static let paperFixed = Color(hex: 0xF4F1EA)

        private static let baseDropletDiameter: CGFloat = 30
        private static let maxDropletDiameter: CGFloat = 96

        var body: some View {
            Group {
                switch presenter.output {
                case .loading:
                    Self.paperFixed.ignoresSafeArea()
                case .showReveal(let color, let dismissing):
                    if let recipe = color.recipe, !recipe.mix.isEmpty {
                        content(color: color, recipe: recipe, dismissing: dismissing)
                    } else {
                        Rectangle()
                            .fill(color.color)
                            .ignoresSafeArea()
                            .task {
                                try? await Task.sleep(for: .seconds(2))
                                presenter.eventDismiss()
                            }
                    }
                case .showError:
                    Self.paperFixed.ignoresSafeArea()
                }
            }
            .onAppear {
                if case .showError = presenter.output {
                    presenter.eventDismiss()
                } else {
                    presenter.eventViewAppeared()
                }
            }
        }

        @ViewBuilder
        private func content(color: ColorEntity, recipe: RecipeEntity, dismissing: Bool) -> some View {
            GeometryReader { geo in
                let swirlCenter = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.28)

                ZStack {
                    Self.paperFixed.ignoresSafeArea()

                    // Swirling spheres at the top
                    if enteredCount > 0 && !pouring {
                        swirlView(recipe: recipe, swirlCenter: swirlCenter)
                    }

                    // Currently entering strip (slide → held → heldShifted → morph)
                    if let idx = currentColorIdx, stripState != .none {
                        let hue = recipe.mix[idx]
                        let percent = Int(round(Double(hue.parts) / Double(recipe.totalParts) * 100))
                        morphingStrip(
                            hue: hue,
                            percent: percent,
                            geo: geo,
                            swirlCenter: swirlCenter
                        )
                    }

                    // Sub-bubble splash spheres around the burst
                    if exploding && !pouring {
                        ForEach(0..<bubbleOffsets.count, id: \.self) { i in
                            let offset = bubbleOffsets[i]
                            let d = offset.size * bubbleScales[i]
                            sphere(color: color.color, diameter: d)
                                .position(
                                    x: swirlCenter.x + offset.x,
                                    y: swirlCenter.y + offset.y
                                )
                        }
                    }

                    // Main explosion sphere
                    if exploding {
                        sphere(color: color.color, diameter: explosionDiameter)
                            .position(swirlCenter)
                            .opacity(pouring ? 0 : 1)
                            .animation(.easeOut(duration: 0.4), value: pouring)
                    }

                    // Clean pour cascade (no drips)
                    if pouring {
                        Rectangle()
                            .fill(color.color)
                            .overlay(
                                LinearGradient(
                                    stops: [
                                        .init(color: Color.white.opacity(0.08), location: 0.0),
                                        .init(color: Color.clear, location: 0.5),
                                        .init(color: Color.black.opacity(0.18), location: 1.0),
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: geo.size.width, height: pourHeight)
                            .position(x: geo.size.width / 2, y: pourHeight / 2)
                            .shadow(color: .black.opacity(0.25), radius: 16, x: 0, y: 10)
                    }
                }
                .ignoresSafeArea()
                .offset(y: revealOffset)
            }
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture { presenter.eventDismiss() }
            .opacity(dismissing ? 0 : 1)
            .animation(.easeInOut(duration: 0.48), value: dismissing)
            .preferredColorScheme(.light)
            .task { await runChoreography(color: color, recipe: recipe) }
        }

        // MARK: - 3D sphere helper

        /// A coloured ball rendered with a radial top-left highlight + bottom-right
        /// shadow + drop shadow, so it reads as a 3D sphere.
        @ViewBuilder
        private func sphere(color: Color, diameter: CGFloat) -> some View {
            Circle()
                .fill(color)
                .overlay(
                    sphericalGloss(diameter: diameter)
                        .clipShape(Circle())
                )
                .frame(width: diameter, height: diameter)
                .shadow(
                    color: .black.opacity(0.38),
                    radius: max(2, diameter * 0.14),
                    x: 0,
                    y: max(1, diameter * 0.08)
                )
        }

        /// Two stacked radial gradients that, when overlaid on a coloured shape,
        /// give it a 3D sphere look (highlight + occlusion).
        @ViewBuilder
        private func sphericalGloss(diameter: CGFloat) -> some View {
            ZStack {
                // Top-left specular highlight
                RadialGradient(
                    colors: [
                        Color.white.opacity(0.55),
                        Color.white.opacity(0),
                    ],
                    center: UnitPoint(x: 0.3, y: 0.25),
                    startRadius: 0,
                    endRadius: max(1, diameter * 0.55)
                )
                // Bottom-right occlusion
                RadialGradient(
                    colors: [
                        Color.black.opacity(0),
                        Color.black.opacity(0.38),
                    ],
                    center: UnitPoint(x: 0.7, y: 0.78),
                    startRadius: max(1, diameter * 0.2),
                    endRadius: max(2, diameter * 0.6)
                )
            }
        }

        // MARK: - Swirl (continuous orbital motion with per-sphere sizing)

        @ViewBuilder
        private func swirlView(recipe: RecipeEntity, swirlCenter: CGPoint) -> some View {
            TimelineView(.animation) { context in
                let elapsed = max(0, context.date.timeIntervalSinceReferenceDate - swirlStartTime)
                let baseAngle = elapsed * angularSpeed
                let n = max(recipe.mix.count, 1)

                ZStack {
                    ForEach(0..<min(enteredCount, recipe.mix.count), id: \.self) { i in
                        let hue = recipe.mix[i]
                        let pigmentColor = Color(hexString: hue.hex) ?? .gray
                        let offset = Double(i) * 2.0 * .pi / Double(n)
                        let angle = baseAngle + offset
                        let x = swirlCenter.x + CGFloat(cos(angle)) * orbitRadius
                        let y = swirlCenter.y + CGFloat(sin(angle)) * orbitRadius
                        let diameter = dropletSize(parts: hue.parts, totalParts: recipe.totalParts)

                        sphere(color: pigmentColor, diameter: diameter)
                            .position(x: x, y: y)
                    }
                }
            }
        }

        private func dropletSize(parts: Int, totalParts: Int) -> CGFloat {
            let share = CGFloat(parts) / CGFloat(max(totalParts, 1))
            let target = min(
                Self.maxDropletDiameter,
                Self.baseDropletDiameter + (Self.maxDropletDiameter - Self.baseDropletDiameter) * share * 1.5
            )
            return Self.baseDropletDiameter
                + (target - Self.baseDropletDiameter) * percentageScale
        }

        // MARK: - Morphing strip (3D card → 3D sphere)

        @ViewBuilder
        private func morphingStrip(
            hue: RecipeMixEntity,
            percent: Int,
            geo: GeometryProxy,
            swirlCenter: CGPoint
        ) -> some View {
            let pigmentColor = Color(hexString: hue.hex) ?? .gray
            let labelColor = stripLabelColor(forHex: hue.hex)

            let isMorphed = stripState == .morphing
            let shifted = stripState == .heldShifted
            let textVisible = stripState == .held || stripState == .heldShifted
            let stripWidth: CGFloat = 340
            let stripHeight: CGFloat = 72
            let dropletSize: CGFloat = 30

            let currentWidth: CGFloat = isMorphed ? dropletSize : stripWidth
            let currentHeight: CGFloat = isMorphed ? dropletSize : stripHeight
            let cornerRad: CGFloat = isMorphed ? dropletSize / 2 : 14

            let centerX = geo.size.width / 2
            let centerY = geo.size.height * 0.55

            let posX: CGFloat = isMorphed ? swirlCenter.x : centerX
            let posY: CGFloat = isMorphed ? swirlCenter.y : centerY

            let slideOffset: CGFloat = stripState == .sliding ? -(geo.size.width + 50) : 0

            ZStack {
                // 3D body — base colour + spherical gloss + pronounced drop shadow
                RoundedRectangle(cornerRadius: cornerRad)
                    .fill(pigmentColor)
                    .overlay(
                        sphericalGloss(diameter: max(currentWidth, currentHeight))
                            .clipShape(RoundedRectangle(cornerRadius: cornerRad))
                    )
                    .frame(width: currentWidth, height: currentHeight)
                    .shadow(color: .black.opacity(0.4), radius: 14, x: 0, y: 10)

                // Name + Hex — slides left when shifted
                VStack(alignment: .leading, spacing: 4) {
                    Text(hue.name.uppercased())
                        .font(CotdFont.label)
                        .tracking(11 * 0.18)
                        .foregroundStyle(labelColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text(hue.hex.uppercased())
                        .font(CotdFont.monoMicro)
                        .tracking(10 * 0.06)
                        .foregroundStyle(labelColor.opacity(0.7))
                }
                .fixedSize()
                .offset(x: shifted ? -85 : 0)
                .opacity(textVisible && !isMorphed ? 1 : 0)

                // Percentage — fades in on the right when shifted
                Text("\(percent)%")
                    .font(.system(size: 22, weight: .medium, design: .monospaced))
                    .foregroundStyle(labelColor)
                    .offset(x: 112)
                    .opacity(shifted && !isMorphed ? 1 : 0)
            }
            .position(x: posX, y: posY)
            .offset(x: slideOffset)
        }

        private func stripLabelColor(forHex hex: String) -> Color {
            let trimmed = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
            guard let value = UInt32(trimmed, radix: 16) else { return Color.white.opacity(0.88) }
            let r = Double((value >> 16) & 0xFF) / 255
            let g = Double((value >> 8) & 0xFF) / 255
            let b = Double(value & 0xFF) / 255
            let lum = 0.299 * r + 0.587 * g + 0.114 * b
            return lum > 0.6 ? CotdColor.ink.opacity(0.78) : Color.white.opacity(0.92)
        }

        // MARK: - Choreography

        private func runChoreography(color: ColorEntity, recipe: RecipeEntity) async {
            // 0.2s: settle on paper
            try? await Task.sleep(for: .milliseconds(200))

            // For each pigment: slide → held → heldShifted → morph
            for (i, _) in recipe.mix.enumerated() {
                currentColorIdx = i
                stripState = .sliding
                try? await Task.sleep(for: .milliseconds(30))

                withAnimation(.easeOut(duration: 0.5)) {
                    stripState = .held
                }
                try? await Task.sleep(for: .milliseconds(2_000))

                withAnimation(.easeInOut(duration: 0.4)) {
                    stripState = .heldShifted
                }
                try? await Task.sleep(for: .milliseconds(600))

                if i == 0 {
                    swirlStartTime = Date().timeIntervalSinceReferenceDate
                }

                withAnimation(.timingCurve(0.5, 0, 0.4, 1, duration: 1.0)) {
                    stripState = .morphing
                }
                try? await Task.sleep(for: .milliseconds(1_000))

                enteredCount = i + 1
                currentColorIdx = nil
                stripState = .none
            }

            // Brief breath before swirl ramp-up
            try? await Task.sleep(for: .milliseconds(400))

            // 5s spin phase: 4s acceleration + growth to percentage sizes
            withAnimation(.easeIn(duration: 4.0)) {
                orbitRadius = 135
                percentageScale = 1.0
                angularSpeed = 7.0
            }
            try? await Task.sleep(for: .milliseconds(4_000))

            // 1s rapid collapse + furious final spin
            withAnimation(.easeIn(duration: 1.0)) {
                orbitRadius = 0
                angularSpeed = 14.0
            }
            try? await Task.sleep(for: .milliseconds(1_000))

            // 0.5s: main burst + satellite bubbles pop
            exploding = true
            withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) {
                explosionDiameter = 700
            }
            for i in 0..<bubbleScales.count {
                withAnimation(
                    .spring(response: 0.4, dampingFraction: 0.5)
                        .delay(Double(i) * 0.07)
                ) {
                    bubbleScales[i] = bubbleOffsets[i].scale
                }
            }
            try? await Task.sleep(for: .milliseconds(500))

            // 1s: burst blooms, bubbles fade, pour starts
            withAnimation(.easeOut(duration: 1.0)) {
                explosionDiameter = 1300
            }
            for i in 0..<bubbleScales.count {
                withAnimation(.easeOut(duration: 0.7).delay(0.2)) {
                    bubbleScales[i] = 0
                }
            }
            try? await Task.sleep(for: .milliseconds(300))
            pouring = true
            withAnimation(.easeOut(duration: 0.7)) {
                pourHeight = 450
            }
            try? await Task.sleep(for: .milliseconds(700))

            // 2.5s: clean pour cascade (no drips) — paint floods down with depth shading
            withAnimation(.easeIn(duration: 2.5)) {
                pourHeight = 2_800
            }
            try? await Task.sleep(for: .milliseconds(2_500))

            // Slide whole reveal up to expose Today
            withAnimation(.timingCurve(0.65, 0, 0.3, 1, duration: 0.7)) {
                revealOffset = -2_800
            }
            try? await Task.sleep(for: .milliseconds(700))

            presenter.eventDismiss()
        }
    }
}
