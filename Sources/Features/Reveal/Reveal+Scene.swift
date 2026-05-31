import SwiftUI

extension Reveal {
    struct Scene: View {
        @State var presenter: Presenter

        @State private var prePlacardHidden = false
        @State private var bandRevealed = false
        @State private var labelShown = false
        @State private var nameShown = false
        @State private var metaShown = false
        @State private var hintShown = false
        @State private var hintPulse = false

        var body: some View {
            Group {
                switch presenter.output {
                case .loading:
                    CotdColor.paper.ignoresSafeArea()
                case .showReveal(let color, let dismissing):
                    content(color: color, dismissing: dismissing)
                case .showError:
                    CotdColor.paper.ignoresSafeArea()
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
        private func content(color: ColorEntity, dismissing: Bool) -> some View {
            ZStack {
                CotdColor.paper

                // 1) Pre-reveal placard
                VStack(spacing: 8) {
                    SectionLabel("Colour of the Day")
                    Text(color.date)
                        .font(CotdFont.italicSmall)
                        .foregroundStyle(CotdColor.inkFaint)
                }
                .opacity(prePlacardHidden ? 0 : 1)

                // 2) The colour band — scales Y from center
                Rectangle()
                    .fill(color.color)
                    .scaleEffect(x: 1, y: bandRevealed ? 1 : 0, anchor: .center)
                    .ignoresSafeArea()

                // 3) On-color content stack
                VStack(spacing: 0) {
                    Text("Today’s colour is".uppercased())
                        .font(CotdFont.mastheadLabel)
                        .tracking(11 * 0.22)
                        .foregroundStyle(color.onColor.opacity(0.6))
                        .opacity(labelShown ? 1 : 0)
                        .offset(y: labelShown ? 0 : 16)

                    Text(color.name)
                        .font(CotdFont.displayMedium)
                        .tracking(54 * -0.015)
                        .foregroundStyle(color.onColor)
                        .multilineTextAlignment(.center)
                        .opacity(nameShown ? 1 : 0)
                        .offset(y: nameShown ? 0 : 16)
                        .padding(.top, 18)

                    Text("\(color.hex.uppercased()) · RGB \(color.rgb.r) \(color.rgb.g) \(color.rgb.b)")
                        .font(CotdFont.monoChip)
                        .tracking(13 * 0.04)
                        .foregroundStyle(color.onColor.opacity(0.85))
                        .opacity(metaShown ? 1 : 0)
                        .offset(y: metaShown ? 0 : 16)
                        .padding(.top, 18)
                }
                .padding(.horizontal, 34)

                // 4) Bottom hint
                VStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Rectangle()
                            .fill(color.onColor.opacity(0.4))
                            .frame(width: 26, height: 1)
                        Text("Tap to explore")
                            .font(CotdFont.captionSmall)
                            .tracking(12 * 0.08)
                            .foregroundStyle(color.onColor.opacity(hintPulse ? 1.0 : 0.55))
                    }
                    .opacity(hintShown ? 1 : 0)
                    .offset(y: hintShown ? 0 : 16)
                    .padding(.bottom, 54)
                }
            }
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture { presenter.eventDismiss() }
            .opacity(dismissing ? 0 : 1)
            .scaleEffect(dismissing ? 1.04 : 1)
            .animation(.easeInOut(duration: 0.48), value: dismissing)
            .task { await runChoreography() }
        }

        // MARK: - Animation choreography

        private func runChoreography() async {
            // 0.60s: band grows
            try? await Task.sleep(for: .milliseconds(600))
            withAnimation(.timingCurve(0.7, 0, 0.2, 1, duration: 0.9)) {
                bandRevealed = true
            }

            // 0.85s: pre-reveal placard fades out
            try? await Task.sleep(for: .milliseconds(250))
            withAnimation(.easeOut(duration: 0.4)) {
                prePlacardHidden = true
            }

            // 1.35s: small label rises
            try? await Task.sleep(for: .milliseconds(500))
            withAnimation(.easeOut(duration: 0.7)) {
                labelShown = true
            }

            // 1.55s: colour name rises
            try? await Task.sleep(for: .milliseconds(200))
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                nameShown = true
            }

            // 1.95s: metadata rises
            try? await Task.sleep(for: .milliseconds(400))
            withAnimation(.easeOut(duration: 0.7)) {
                metaShown = true
            }

            // 2.80s: bottom hint rises
            try? await Task.sleep(for: .milliseconds(850))
            withAnimation(.easeOut(duration: 0.8)) {
                hintShown = true
            }

            // 3.40s: start hint pulse
            try? await Task.sleep(for: .milliseconds(600))
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                hintPulse = true
            }

            // 5.20s: auto-advance
            try? await Task.sleep(for: .milliseconds(1800))
            presenter.eventDismiss()
        }
    }
}
