import SwiftUI
import SharedUI

public struct AnchorPreferenceLayoutDemoView: View {
    @State private var selectedMetricID: String?

    private let metrics: [ConversionMetric] = [
        ConversionMetric(id: "onboarding", title: "Onboarding", shortLabel: "ONB", value: 46, color: .mint),
        ConversionMetric(id: "activation", title: "Activation", shortLabel: "ACT", value: 62, color: .teal),
        ConversionMetric(id: "retention", title: "Retention", shortLabel: "RET", value: 74, color: .blue),
        ConversionMetric(id: "referral", title: "Referral", shortLabel: "REF", value: 58, color: .indigo),
        ConversionMetric(id: "revenue", title: "Revenue", shortLabel: "REV", value: 81, color: .orange)
    ]

    public init() {}

    public var body: some View {
        DemoScreen(
            title: "Anchor Preferences",
            summary: "Capture child bounds and project them into an overlay for precision callouts."
        ) {
            Text("Tap a bar to pin a tooltip using anchor-based geometry.")
                .font(.callout)
                .foregroundStyle(.secondary)

            HStack(alignment: .bottom, spacing: 12) {
                ForEach(metrics) { metric in
                    VStack(spacing: 8) {
                        Capsule(style: .continuous)
                            .fill(metric.color.gradient)
                            .frame(width: 40, height: max(CGFloat(metric.value) * 1.7, 36))
                            .overlay(alignment: .top) {
                                if selectedMetricID == metric.id {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .padding(.top, 6)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedMetricID = metric.id
                            }
                            // Anchor preferences let a child expose its frame to ancestors.
                            .anchorPreference(
                                key: BarBoundsPreferenceKey.self,
                                value: .bounds
                            ) { anchor in
                                [metric.id: anchor]
                            }

                        Text(metric.shortLabel)
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 240, alignment: .bottom)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.thinMaterial)
            )
            .overlayPreferenceValue(BarBoundsPreferenceKey.self) { anchors in
                GeometryReader { proxy in
                    if let selectedMetricID,
                       let anchor = anchors[selectedMetricID],
                       let metric = metrics.first(where: { $0.id == selectedMetricID }) {
                        let rect = proxy[anchor]

                        // Debugging note: if this tooltip drifts, validate you are reading
                        // the anchor in the same coordinate space where it is placed.
                        TooltipView(metric: metric)
                            .position(
                                x: rect.midX,
                                y: max(rect.minY - 22, 18)
                            )
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.78), value: selectedMetricID)
        }
        .onAppear {
            selectedMetricID = metrics.first?.id
        }
    }
}

private struct ConversionMetric: Identifiable {
    let id: String
    let title: String
    let shortLabel: String
    let value: Int
    let color: Color
}

private struct TooltipView: View {
    let metric: ConversionMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(metric.title)
                .font(.caption.bold())
            Text("\(metric.value)%")
                .font(.caption2.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 1)
        )
    }
}

private struct BarBoundsPreferenceKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]

    static func reduce(value: inout [String: Anchor<CGRect>], nextValue: () -> [String: Anchor<CGRect>]) {
        value.merge(nextValue()) { _, new in new }
    }
}

#Preview {
    NavigationStack {
        AnchorPreferenceLayoutDemoView()
    }
}
