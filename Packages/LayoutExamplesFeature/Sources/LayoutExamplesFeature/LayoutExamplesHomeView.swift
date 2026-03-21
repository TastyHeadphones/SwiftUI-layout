import SwiftUI

public struct LayoutExamplesHomeView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section("Advanced Layout Demos") {
                    NavigationLink {
                        AnyLayoutAdaptationDemoView()
                    } label: {
                        DemoRow(
                            title: "AnyLayout Adaptation",
                            subtitle: "Switch stack direction while preserving child identity.",
                            symbol: "rectangle.3.group.bubble.left"
                        )
                    }

                    NavigationLink {
                        FlowLayoutDemoView()
                    } label: {
                        DemoRow(
                            title: "Custom Flow Layout",
                            subtitle: "Build a wrapping chip layout with the Layout protocol.",
                            symbol: "square.grid.3x2"
                        )
                    }

                    NavigationLink {
                        AnchorPreferenceLayoutDemoView()
                    } label: {
                        DemoRow(
                            title: "Anchor Preferences",
                            subtitle: "Measure child bounds and pin overlays precisely.",
                            symbol: "scope"
                        )
                    }

                    NavigationLink {
                        ViewThatFitsDashboardDemoView()
                    } label: {
                        DemoRow(
                            title: "ViewThatFits Dashboard",
                            subtitle: "Provide responsive layouts with ordered fallbacks.",
                            symbol: "rectangle.2.swap"
                        )
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Layout Showcase")
        }
    }
}

private struct DemoRow: View {
    let title: String
    let subtitle: String
    let symbol: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.tint)
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LayoutExamplesHomeView()
}
