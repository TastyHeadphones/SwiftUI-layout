import SwiftUI
import SharedUI

public struct TabBarLayoutShowcaseDemoView: View {
    @State private var selectedTab: LayoutTab = .stacks

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            StacksTab()
                .tag(LayoutTab.stacks)
                .tabItem {
                    Label("Stacks", systemImage: "square.stack.3d.up")
                }

            GridTab()
                .tag(LayoutTab.grids)
                .tabItem {
                    Label("Grids", systemImage: "square.grid.3x3")
                }

            AdaptiveTab()
                .tag(LayoutTab.adaptive)
                .tabItem {
                    Label("Adaptive", systemImage: "rectangle.3.group")
                }

            OverlayTab()
                .tag(LayoutTab.overlay)
                .tabItem {
                    Label("Overlay", systemImage: "rectangle.on.rectangle")
                }
        }
        .navigationTitle("Tab Bar Layout Lab")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private enum LayoutTab: String {
    case stacks
    case grids
    case adaptive
    case overlay
}

private struct StacksTab: View {
    private let priorities: [(title: String, alignment: HorizontalAlignment)] = [
        ("Leading", .leading),
        ("Center", .center),
        ("Trailing", .trailing)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Stack Layouts")
                    .font(.title2.weight(.bold))

                DemoCard(title: "VStack + HStack", systemImage: "rectangle.split.3x1") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Compose rows and columns with explicit alignment guides.")
                            .font(.callout)
                            .foregroundStyle(.secondary)

                        ForEach(priorities, id: \.title) { item in
                            VStack(alignment: item.alignment, spacing: 6) {
                                Text(item.title)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                HStack {
                                    Capsule().fill(.mint.gradient).frame(width: 52, height: 16)
                                    Capsule().fill(.cyan.gradient).frame(width: 74, height: 16)
                                    Capsule().fill(.blue.gradient).frame(width: 38, height: 16)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: item.alignment == .leading ? .leading : item.alignment == .trailing ? .trailing : .center)
                        }
                    }
                }

                DemoCard(title: "ZStack Layering", systemImage: "square.3.layers.3d") {
                    // Debugging note: if touches feel off, inspect the layer order and
                    // contentShape boundaries in Xcode's View Debugger.
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.indigo.gradient)
                            .frame(height: 160)

                        Circle()
                            .fill(.white.opacity(0.24))
                            .frame(width: 130, height: 130)
                            .offset(x: 24, y: -18)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Layered Surface")
                                .font(.headline)
                            Text("ZStack composes depth while preserving local alignment.")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.92))
                        }
                        .foregroundStyle(.white)
                        .padding(16)
                    }
                }
            }
            .padding(20)
        }
        .background(LayoutDebugBackdrop())
    }
}

private struct GridTab: View {
    private let cards: [MetricCard] = [
        MetricCard(name: "Latency", value: "183ms", tint: .green),
        MetricCard(name: "Throughput", value: "4.2k/s", tint: .blue),
        MetricCard(name: "Error", value: "0.08%", tint: .orange),
        MetricCard(name: "Saturation", value: "71%", tint: .pink)
    ]

    private let tags = [
        "Hero", "Sidebar", "Toolbar", "Inspector", "Footer", "Modal", "Banner", "Chart", "Map"
    ]

    private let columns = [
        GridItem(.adaptive(minimum: 84), spacing: 8)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Grid Layouts")
                    .font(.title2.weight(.bold))

                DemoCard(title: "Grid", systemImage: "square.grid.2x2") {
                    // Grid keeps deterministic row/column alignment, useful for metrics.
                    Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                        GridRow {
                            header("Metric")
                            header("Value")
                        }

                        ForEach(cards) { metric in
                            GridRow {
                                Text(metric.name)
                                Text(metric.value)
                                    .font(.body.monospacedDigit().weight(.semibold))
                                    .foregroundStyle(metric.tint)
                            }
                        }
                    }
                }

                DemoCard(title: "LazyVGrid Adaptive", systemImage: "square.grid.3x3") {
                    Text("Adaptive columns automatically recalculate as width changes.")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                                .font(.footnote.weight(.semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color(uiColor: .secondarySystemBackground))
                                )
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(LayoutDebugBackdrop())
    }

    private func header(_ title: String) -> some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct AdaptiveTab: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var forceVertical = false

    private let services: [ServiceStatus] = [
        ServiceStatus(name: "API", status: "Healthy", tint: .green),
        ServiceStatus(name: "Queue", status: "Draining", tint: .orange),
        ServiceStatus(name: "Storage", status: "Nominal", tint: .blue)
    ]

    private var activeLayout: AnyLayout {
        let useVertical = forceVertical || horizontalSizeClass == .compact
        return useVertical
            ? AnyLayout(VStackLayout(spacing: 10))
            : AnyLayout(HStackLayout(alignment: .center, spacing: 10))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Adaptive Layouts")
                    .font(.title2.weight(.bold))

                Toggle("Force vertical mode", isOn: $forceVertical)
                    .font(.headline)

                DemoCard(title: "AnyLayout Switching", systemImage: "arrow.triangle.branch") {
                    // Debugging note: AnyLayout preserves child identity during container swaps.
                    activeLayout {
                        ForEach(services) { item in
                            serviceBadge(item)
                        }
                    }
                    .animation(.snappy(duration: 0.3), value: forceVertical)
                    .animation(.snappy(duration: 0.3), value: horizontalSizeClass)
                }

                DemoCard(title: "ViewThatFits Fallbacks", systemImage: "rectangle.2.swap") {
                    // Candidate order matters: put the highest-fidelity layout first.
                    ViewThatFits(in: .horizontal) {
                        HStack(spacing: 8) {
                            ForEach(services) { item in
                                serviceBadge(item)
                            }
                        }
                        VStack(spacing: 8) {
                            ForEach(services) { item in
                                serviceBadge(item)
                            }
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(LayoutDebugBackdrop())
    }

    private func serviceBadge(_ item: ServiceStatus) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(item.tint)
                .frame(width: 8, height: 8)
            Text(item.name)
                .fontWeight(.semibold)
            Text(item.status)
                .foregroundStyle(.secondary)
        }
        .font(.subheadline)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct OverlayTab: View {
    @State private var selectedCardID = 0
    private let cardColors: [Color] = [.mint, .blue, .orange, .indigo]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Overlay & Insets")
                    .font(.title2.weight(.bold))

                DemoCard(title: "GeometryReader + Overlay", systemImage: "viewfinder") {
                    GeometryReader { proxy in
                        // Debugging note: GeometryReader always takes all offered space.
                        // Constrain it explicitly to avoid unexpected expansion.
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color(uiColor: .secondarySystemBackground))
                            .overlay(alignment: .topLeading) {
                                Text("\(Int(proxy.size.width))×\(Int(proxy.size.height))")
                                    .font(.caption.monospacedDigit())
                                    .padding(8)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                                    .padding(10)
                            }
                    }
                    .frame(height: 140)
                }

                DemoCard(title: "safeAreaInset Control Bar", systemImage: "dock.rectangle") {
                    Text("Horizontal cards reserve bottom space via safeAreaInset.")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(Array(cardColors.enumerated()), id: \.offset) { index, color in
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(color.gradient)
                                    .frame(width: 180, height: 120)
                                    .overlay {
                                        Text("Card \(index + 1)")
                                            .font(.headline.weight(.semibold))
                                            .foregroundStyle(.white)
                                    }
                                    .onTapGesture {
                                        selectedCardID = index
                                    }
                            }
                        }
                        .padding(.horizontal, 2)
                    }
                    .safeAreaInset(edge: .bottom) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                            Text("Selected card: \(selectedCardID + 1)")
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                            Button("Reset") {
                                selectedCardID = 0
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(12)
                        .background(.ultraThinMaterial)
                    }
                    .frame(height: 220)
                }
            }
            .padding(20)
        }
        .background(LayoutDebugBackdrop())
    }
}

private struct MetricCard: Identifiable {
    let id = UUID()
    let name: String
    let value: String
    let tint: Color
}

private struct ServiceStatus: Identifiable {
    let id = UUID()
    let name: String
    let status: String
    let tint: Color
}

#Preview {
    NavigationStack {
        TabBarLayoutShowcaseDemoView()
    }
}
