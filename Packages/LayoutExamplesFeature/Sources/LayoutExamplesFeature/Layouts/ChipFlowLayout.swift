import SwiftUI

public struct ChipFlowLayout: Layout {
    public var horizontalSpacing: CGFloat
    public var verticalSpacing: CGFloat

    public init(horizontalSpacing: CGFloat = 8, verticalSpacing: CGFloat = 8) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
    }

    public func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maxWidth = proposal.width ?? .greatestFiniteMagnitude
        let rows = makeRows(maxWidth: maxWidth, subviews: subviews)

        return measuredSize(from: rows, constrainedTo: proposal.width)
    }

    public func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let rows = makeRows(maxWidth: bounds.width, subviews: subviews)
        var currentY = bounds.minY

        for row in rows {
            for element in row.elements {
                let point = CGPoint(
                    x: bounds.minX + element.xOffset,
                    y: currentY
                )

                subviews[element.index].place(
                    at: point,
                    anchor: .topLeading,
                    proposal: ProposedViewSize(
                        width: element.size.width,
                        height: element.size.height
                    )
                )
            }

            currentY += row.height + verticalSpacing
        }
    }
}

private extension ChipFlowLayout {
    struct Row {
        struct Element {
            let index: Int
            let size: CGSize
            let xOffset: CGFloat
        }

        var elements: [Element] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    func makeRows(maxWidth: CGFloat, subviews: Subviews) -> [Row] {
        let effectiveWidth = max(maxWidth, 0)
        var rows: [Row] = []
        var currentRow = Row()

        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let spacing = currentRow.elements.isEmpty ? 0 : horizontalSpacing
            let nextWidth = currentRow.width + spacing + size.width

            if !currentRow.elements.isEmpty && nextWidth > effectiveWidth {
                rows.append(currentRow)
                currentRow = Row()
            }

            let xOffset = currentRow.elements.isEmpty ? 0 : currentRow.width + horizontalSpacing
            currentRow.elements.append(
                Row.Element(
                    index: index,
                    size: size,
                    xOffset: xOffset
                )
            )
            currentRow.width = xOffset + size.width
            currentRow.height = max(currentRow.height, size.height)
        }

        if !currentRow.elements.isEmpty {
            rows.append(currentRow)
        }

        return rows
    }

    func measuredSize(from rows: [Row], constrainedTo proposedWidth: CGFloat?) -> CGSize {
        let contentWidth = rows.map(\.width).max() ?? 0
        let contentHeight = rows.reduce(CGFloat.zero) { partialResult, row in
            partialResult + row.height
        } + CGFloat(max(rows.count - 1, 0)) * verticalSpacing

        let resolvedWidth: CGFloat
        if let proposedWidth, proposedWidth.isFinite {
            resolvedWidth = proposedWidth
        } else {
            resolvedWidth = contentWidth
        }

        return CGSize(width: resolvedWidth, height: contentHeight)
    }
}
