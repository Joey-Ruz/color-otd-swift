import SwiftUI

extension Reveal {
    /// Cold-launch reveal — a multi-stage theatrical choreography (~25s total).
    ///
    /// Notably during the morph: the strip glides along a quadratic Bezier curve
    /// to the exact orbit position where its sphere will appear when the swirl
    /// picks it up — arriving along the tangent of the orbit so it appears to
    /// merge into the rotation rather than snap in.
    struct Scene: View {
        @State var presenter: Presenter

        // Phase tracking
        @State private var enteredCount: Int = 0
        @State private var currentColorIdx: Int? = nil
        @State private var stripState: StripState = .none
        @State private var swirlStartTime: TimeInterval = 0
        @State private var morphStartTime: TimeInterval = 0
        @State private var morphTargetIndex: Int = 0
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

        // Sub-bubble offsets relative to swirl centre (x, y, scale, size)
        private let bubbleOffsets: [(x: CGFloat, y: CGFloat, scale: CGFloat, size: CGFloat)] = [
            (-90, -20, 1.3, 80),
            (70, -60, 0.9, 70),
            (-50, 60, 1.5, 60),
            (95, 35, 0.8, 90),
        ]

        private static let paperFixed = Color(hex: 0xF4F1EA)
        private static let baseDropletDiameter: CGFloat = 30
        private static let maxDropletDiameter: CGFloat = 96
        private static let morphDuration: Double = 1.0

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

                    if enteredCount > 0 && !pouring {
                        swirlView(recipe: recipe, swirlCenter: swirlCenter)
                    }

                    if let idx = currentColorIdx, stripState != .none {
                        let hue = recipe.mix[idx]
                        let percent = Int(round(Double(hue.parts) / Double(recipe.totalParts) * 100))
                        morphingStrip(
                            hue: hue,
                            percent: percent,
                            geo: geo,
                            swirlCenter: swirlCenter,
                            recipeMixCount: recipe.mix.count
                        )
                    }

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

                    if exploding {
                        sphere(color: color.color, diameter: explosionDiameter)
                            .position(swirlCenter)
                            .opacity(pouring ? 0 : 1)
                            .animation(.easeOut(duration: 0.4), value: pouring)
                    }

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

        @ViewBuilder
        private func sphericalGloss(diameter: CGFloat) -> some View {
            ZStack {
                RadialGradient(
                    colors: [Color.white.opacity(0.55), Color.white.opacity(0)],
                    center: UnitPoint(x: 0.3, y: 0.25),
                    startRadius: 0,
                    endRadius: max(1, diameter * 0.55)
                )
                RadialGradient(
                    colors: [Color.black.opacity(0), Color.black.opacity(0.38)],
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

        // MARK: - Morphing strip — splits into static (slide/held) and dynamic (morphing)

        @ViewBuilder
        private func morphingStrip(
            hue: RecipeMixEntity,
            percent: Int,
            geo: GeometryProxy,
            swirlCenter: CGPoint,
            recipeMixCount: Int
        ) -> some View {
            let pigmentColor = Color(hexString: hue.hex) ?? .gray
            let labelColor = stripLabelColor(forHex: hue.hex)

            if stripState == .morphing {
                morphTrajectoryStrip(
                    pigmentColor: pigmentColor,
                    geo: geo,
                    swirlCenter: swirlCenter,
                    recipeMixCount: recipeMixCount
                )
            } else {
                staticStrip(
                    hue: hue,
                    percent: percent,
                    pigmentColor: pigmentColor,
                    labelColor: labelColor,
                    geo: geo
                )
            }
        }

        // MARK: Static strip (slide-in, held, heldShifted)

        @ViewBuilder
        private func staticStrip(
            hue: RecipeMixEntity,
            percent: Int,
            pigmentColor: Color,
            labelColor: Color,
            geo: GeometryProxy
        ) -> some View {
            let shifted = stripState == .heldShifted
            let textVisible = stripState == .held || stripState == .heldShifted
            let stripWidth: CGFloat = 340
            let stripHeight: CGFloat = 72
            let cornerRad: CGFloat = 14

            let centerX = geo.size.width / 2
            let centerY = geo.size.height * 0.55
            let slideOffset: CGFloat = stripState == .sliding ? -(geo.size.width + 50) : 0

            ZStack {
                RoundedRectangle(cornerRadius: cornerRad)
                    .fill(pigmentColor)
                    .overlay(
                        sphericalGloss(diameter: max(stripWidth, stripHeight))
                            .clipShape(RoundedRectangle(cornerRadius: cornerRad))
                    )
                    .frame(width: stripWidth, height: stripHeight)
                    .shadow(color: .black.opacity(0.4), radius: 14, x: 0, y: 10)

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
                .opacity(textVisible ? 1 : 0)

                Text("\(percent)%")
                    .font(.system(size: 22, weight: .medium, design: .monospaced))
                    .foregroundStyle(labelColor)
                    .offset(x: 112)
                    .opacity(shifted ? 1 : 0)
            }
            .position(x: centerX, y: centerY)
            .offset(x: slideOffset)
        }

        // MARK: Morph trajectory — Bezier arc into orbit, tangent-matched at landing

        @ViewBuilder
        private func morphTrajectoryStrip(
            pigmentColor: Color,
            geo: GeometryProxy,
            swirlCenter: CGPoint,
            recipeMixCount: Int
        ) -> some View {
            let stripWidth: CGFloat = 340
            let stripHeight: CGFloat = 72
            let dropletSizeEnd: CGFloat = 30
            let startX = geo.size.width / 2
            let startY = geo.size.height * 0.55

            TimelineView(.animation) { context in
                let now = context.date.timeIntervalSinceReferenceDate
                let rawProgress = (now - morphStartTime) / Self.morphDuration
                let progress = min(1.0, max(0.0, rawProgress))
                let eased = easeOutCubic(progress)

                // Predict the swirl slot position at the moment the morph completes
                let morphEndTime = morphStartTime + Self.morphDuration
                let swirlElapsedAtEnd = max(0, morphEndTime - swirlStartTime)
                let baseAngleAtEnd = swirlElapsedAtEnd * angularSpeed
                let n = max(recipeMixCount, 1)
                let targetAngle = baseAngleAtEnd
                    + Double(morphTargetIndex) * 2.0 * .pi / Double(n)

                let targetX = swirlCenter.x + CGFloat(cos(targetAngle)) * orbitRadius
                let targetY = swirlCenter.y + CGFloat(sin(targetAngle)) * orbitRadius

                // Orbit tangent at target — direction of motion at landing
                let tangentDx = CGFloat(-sin(targetAngle))
                let tangentDy = CGFloat(cos(targetAngle))
                // Control point sits "behind" the target along the negative
                // tangent so the curve arrives moving WITH the orbit.
                let tangentLead: CGFloat = orbitRadius * 1.25
                let controlX = targetX - tangentDx * tangentLead
                let controlY = targetY - tangentDy * tangentLead

                // Quadratic Bezier: B(t) = (1-t)² P0 + 2(1-t)t P1 + t² P2
                let t = CGFloat(eased)
                let omt = 1.0 - t
                let x = omt * omt * startX
                    + 2 * omt * t * controlX
                    + t * t * targetX
                let y = omt * omt * startY
                    + 2 * omt * t * controlY
                    + t * t * targetY

                // Linear size + corner interpolation by eased progress
                let currentWidth = stripWidth + (dropletSizeEnd - stripWidth) * t
                let currentHeight = stripHeight + (dropletSizeEnd - stripHeight) * t
                let cornerRad: CGFloat = 14 + (dropletSizeEnd / 2 - 14) * t
                let shadowRadius: CGFloat = 14 - 9 * t
                let shadowY: CGFloat = 10 - 5 * t

                RoundedRectangle(cornerRadius: cornerRad)
                    .fill(pigmentColor)
                    .overlay(
                        sphericalGloss(diameter: max(currentWidth, currentHeight))
                            .clipShape(RoundedRectangle(cornerRadius: cornerRad))
                    )
                    .frame(width: currentWidth, height: currentHeight)
                    .shadow(
                        color: .black.opacity(0.4),
                        radius: max(2, shadowRadius),
                        x: 0,
                        y: max(0, shadowY)
                    )
                    .position(x: x, y: y)
            }
        }

        private func easeOutCubic(_ x: Double) -> Double {
            1 - pow(1 - x, 3)
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
            try? await Task.sleep(for: .milliseconds(200))

            for (i, _) in recipe.mix.enumerated() {
                currentColorIdx = i
                stripState = .sliding
                try? await Task.sleep(for: .milliseconds(30))

                withAnimation(.easeOut(duration: 0.5)) {
                    stripState = .held
                }
                try? await Task.sleep(for: .milliseconds(1_500))

                withAnimation(.easeInOut(duration: 0.4)) {
                    stripState = .heldShifted
                }
                try? await Task.sleep(for: .milliseconds(1_100))

                // Start swirl clock on first morph
                if i == 0 {
                    swirlStartTime = Date().timeIntervalSinceReferenceDate
                }

                // Capture morph start time + slot index BEFORE switching state,
                // so the trajectory predictor lands on the exact orbit position
                // the swirl will render this droplet at.
                morphStartTime = Date().timeIntervalSinceReferenceDate
                morphTargetIndex = i

                // Strip state flips instantly to .morphing — TimelineView takes
                // over rendering position via the Bezier trajectory.
                stripState = .morphing

                try? await Task.sleep(for: .milliseconds(1_000))

                // Hand off — swirl picks up at slot i, position should match
                // the morph's end point precisely.
                enteredCount = i + 1
                currentColorIdx = nil
                stripState = .none
            }

            try? await Task.sleep(for: .milliseconds(400))

            // Phase A — smooth ramp on a clean circular orbit.
            // Orbit radius stays put so the spheres trace the same circle;
            // they only grow in size and speed, on an easeInOut curve so the
            // acceleration is gradual rather than slow→jolt.
            withAnimation(.easeInOut(duration: 4.5)) {
                percentageScale = 1.0
                angularSpeed = 5.0
            }
            try? await Task.sleep(for: .milliseconds(4_500))

            // Phase B — gentle in-spiral toward the centre, picking up a
            // little more speed. easeIn here so motion settles smoothly into
            // the burst instead of stopping abruptly.
            withAnimation(.easeIn(duration: 1.3)) {
                orbitRadius = 0
                angularSpeed = 9.0
            }
            try? await Task.sleep(for: .milliseconds(1_300))

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

            withAnimation(.easeIn(duration: 2.5)) {
                pourHeight = 2_800
            }
            try? await Task.sleep(for: .milliseconds(2_500))

            withAnimation(.timingCurve(0.65, 0, 0.3, 1, duration: 0.7)) {
                revealOffset = -2_800
            }
            try? await Task.sleep(for: .milliseconds(700))

            presenter.eventDismiss()
        }
    }
}
