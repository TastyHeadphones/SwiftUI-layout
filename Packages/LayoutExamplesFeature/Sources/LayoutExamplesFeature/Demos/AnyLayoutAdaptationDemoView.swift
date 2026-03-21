import SwiftUI
import SharedUI

public struct AnyLayoutAdaptationDemoView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var forceVertical = false

    private let insights: [LayoutInsight] = [
        LayoutInsight(
            title: "Identity Preservation",
            detail: "State is retained while switching between HStack and VStack.",
            icon: "person.crop.rectangle.stack"
        ),
        LayoutInsight(
            title: "Animation Friendly",
            detail: "Layout transitions animate without re-instantiating child views.",
            icon: "sparkles.rectangle.stack"
        ),
        LayoutInsight(
            title: "Breakpoint Control",
            detail: "You can switch layout behavior on size class or feature flags.",
            icon: "arrow.triangle.branch"
        )
    ]

    public init() {}

    private var activeLayout: AnyLayout {
        // AnyLayout lets us swap layout containers while preserving child view identity.
        let prefersVertical = forceVertical || horizontalSizeClass == .compact
        return prefersVertical
            ? AnyLayout(VStackLayout(spacing: 12))
            : AnyLayout(HStackLayout(alignment: .top, spacing: 12))
    }

    public var body: some View {
        DemoScreen(
            title: "AnyLayout Adaptation",
            summary: "Swap between horizontal and vertical composition while keeping stable view identity."
        ) {
            Toggle("Force vertical stack", isOn: $forceVertical)
                .font(.headline)

            // Debugging tip: inspect this container in Xcode's View Debugger to confirm
            // children stay alive instead of getting recreated when layout mode changes.
            activeLayout {
                ForEach(insights) { insight in
                    DemoCard(title: insight.title, systemImage: insight.icon) {
                        Text(insight.detail)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .animation(.snappy(duration: 0.35), value: forceVertical)
            .animation(.snappy(duration: 0.35), value: horizontalSizeClass)
        }
    }
}

private struct LayoutInsight: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let icon: String
}

#Preview {
    NavigationStack {
        AnyLayoutAdaptationDemoView()
    }
}
