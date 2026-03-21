import SwiftUI
import SharedUI

public struct FlowLayoutDemoView: View {
    @State private var selectedTags: Set<String> = ["SwiftUI", "Layout"]

    private let tags: [String] = [
        "SwiftUI",
        "Layout",
        "Geometry",
        "Grid",
        "Animation",
        "ViewThatFits",
        "PreferenceKey",
        "AnyLayout",
        "safeAreaInset",
        "Container"
    ]

    public init() {}

    public var body: some View {
        DemoScreen(
            title: "Custom Flow Layout",
            summary: "Implement a wrapping chip container using the Layout protocol."
        ) {
            Text("Tap tags to observe how line wrapping recomputes as intrinsic widths change.")
                .font(.callout)
                .foregroundStyle(.secondary)

            // This custom layout places chips row by row and wraps when width is exhausted.
            // Use `_printChanges()` or the View Debugger to inspect placement recalculations.
            ChipFlowLayout(horizontalSpacing: 8, verticalSpacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    Button {
                        toggle(tag)
                    } label: {
                        SelectionChip(
                            title: tag,
                            isSelected: selectedTags.contains(tag)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            DemoCard(title: "Debugging Consideration", systemImage: "ladybug") {
                Text("If wrapping behaves unexpectedly, log each subview’s `sizeThatFits(.unspecified)` result in the custom Layout implementation.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func toggle(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
}

#Preview {
    NavigationStack {
        FlowLayoutDemoView()
    }
}
