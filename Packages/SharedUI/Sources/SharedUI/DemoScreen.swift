import SwiftUI

public struct DemoScreen<Content: View>: View {
    private let title: String
    private let summary: String
    private let content: Content

    public init(
        title: String,
        summary: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.summary = summary
        self.content = content()
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.largeTitle.bold())
                    Text(summary)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }

                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .background(LayoutDebugBackdrop())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

public struct LayoutDebugBackdrop: View {
    private let spacing: CGFloat

    public init(spacing: CGFloat = 24) {
        self.spacing = spacing
    }

    public var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(uiColor: .systemBackground),
                    Color(uiColor: .secondarySystemBackground)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            GeometryReader { _ in
                Canvas { context, size in
                    var path = Path()

                    stride(from: CGFloat.zero, through: size.width, by: spacing).forEach { x in
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                    }

                    stride(from: CGFloat.zero, through: size.height, by: spacing).forEach { y in
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                    }

                    context.stroke(
                        path,
                        with: .color(.secondary.opacity(0.08)),
                        lineWidth: 0.5
                    )
                }
            }
        }
        .ignoresSafeArea()
    }
}
