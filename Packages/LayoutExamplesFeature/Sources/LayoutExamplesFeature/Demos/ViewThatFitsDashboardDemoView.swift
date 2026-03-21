import SwiftUI
import SharedUI

public struct ViewThatFitsDashboardDemoView: View {
    private let metrics: [DashboardMetric] = [
        DashboardMetric(name: "Latency", value: 0.18, tint: .green),
        DashboardMetric(name: "Error Rate", value: 0.05, tint: .red),
        DashboardMetric(name: "Cache Hit", value: 0.92, tint: .blue),
        DashboardMetric(name: "Adoption", value: 0.71, tint: .orange)
    ]

    public init() {}

    public var body: some View {
        DemoScreen(
            title: "ViewThatFits Dashboard",
            summary: "Compose responsive alternatives and let SwiftUI pick the first layout that fits."
        ) {
            Text("Resize the preview or run on multiple devices to inspect fallback ordering.")
                .font(.callout)
                .foregroundStyle(.secondary)

            DemoCard(title: "Adaptive Summary", systemImage: "rectangle.2.swap") {
                // ViewThatFits checks candidates in order and renders the first that fits.
                // Put your highest-fidelity layout first and degraded layouts afterward.
                ViewThatFits(in: .horizontal) {
                    wideSummary
                    compactSummary
                }
            }

            DemoCard(title: "Metric Grid", systemImage: "square.grid.2x2") {
                // Grid gives deterministic column alignment, which helps when comparing metrics.
                Grid(horizontalSpacing: 12, verticalSpacing: 10) {
                    GridRow {
                        Text("Metric").font(.caption.weight(.semibold))
                        Text("Progress").font(.caption.weight(.semibold))
                        Text("Value").font(.caption.weight(.semibold))
                    }

                    ForEach(metrics) { metric in
                        GridRow {
                            Text(metric.name)
                                .font(.subheadline)
                            ProgressView(value: metric.value)
                                .tint(metric.tint)
                            Text(metric.value, format: .percent.precision(.fractionLength(0)))
                                .font(.subheadline.monospacedDigit())
                        }
                    }
                }
            }
        }
    }

    private var wideSummary: some View {
        HStack(spacing: 16) {
            summaryBadge(label: "Deploy", value: "Ready", tint: .green)
            summaryBadge(label: "Build", value: "2m 14s", tint: .blue)
            summaryBadge(label: "Crash-free", value: "99.97%", tint: .orange)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var compactSummary: some View {
        VStack(alignment: .leading, spacing: 10) {
            summaryBadge(label: "Deploy", value: "Ready", tint: .green)
            summaryBadge(label: "Build", value: "2m 14s", tint: .blue)
            summaryBadge(label: "Crash-free", value: "99.97%", tint: .orange)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func summaryBadge(label: String, value: String, tint: Color) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(tint.gradient)
                .frame(width: 8, height: 8)
            Text(label)
                .foregroundStyle(.secondary)
            Text(value)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }
}

private struct DashboardMetric: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
    let tint: Color
}

#Preview {
    NavigationStack {
        ViewThatFitsDashboardDemoView()
    }
}
