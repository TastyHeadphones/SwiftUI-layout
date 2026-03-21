import SwiftUI

public struct SelectionChip: View {
    private let title: String
    private let isSelected: Bool

    public init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }

    public var body: some View {
        Text(title)
            .font(.callout.weight(.semibold))
            .foregroundStyle(isSelected ? Color.white : Color.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule(style: .continuous)
                    .fill(isSelected ? Color.accentColor : Color(uiColor: .tertiarySystemFill))
            )
            .overlay(
                Capsule(style: .continuous)
                    .strokeBorder(.quaternary, lineWidth: isSelected ? 0 : 1)
            )
            .animation(.snappy(duration: 0.25), value: isSelected)
    }
}
