import SwiftUI

/// A text style that applies custom styling to citation badges.
public struct CitationStyle: TextStyle, Sendable {
    /// The foreground color of the citation badge text.
    public var foregroundColor: Color?
    
    /// The background color of the citation badge.
    public var backgroundColor: Color?
    
    /// The font weight to apply to the citation text.
    public var fontWeight: Font.Weight?
    
    /// The corner radius of the citation badge.
    public var cornerRadius: CGFloat
    
    /// The horizontal padding of the citation badge.
    public var horizontalPadding: CGFloat
    
    /// The vertical padding of the citation badge.
    public var verticalPadding: CGFloat
    
    /// Creates a citation style with the specified properties.
    public init(
        foregroundColor: Color? = .white,
        backgroundColor: Color? = .blue.opacity(0.8),
        fontWeight: Font.Weight? = .semibold,
        cornerRadius: CGFloat = 4,
        horizontalPadding: CGFloat = 4,
        verticalPadding: CGFloat = 1
    ) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.fontWeight = fontWeight
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }
}

/// A text style that applies custom styling to artifact references.
public struct ArtifactReferenceStyle: TextStyle, Sendable {
    /// The foreground color of the artifact reference text and icon.
    public var foregroundColor: Color?
    
    /// The background color of the artifact reference.
    public var backgroundColor: Color?
    
    /// The font weight to apply to the artifact reference text.
    public var fontWeight: Font.Weight?
    
    /// The corner radius of the artifact reference.
    public var cornerRadius: CGFloat
    
    /// The horizontal padding of the artifact reference.
    public var horizontalPadding: CGFloat
    
    /// The vertical padding of the artifact reference.
    public var verticalPadding: CGFloat
    
    /// The icon to display before the artifact reference title.
    public var iconName: String
    
    /// Creates an artifact reference style with the specified properties.
    public init(
        foregroundColor: Color? = .purple,
        backgroundColor: Color? = .purple.opacity(0.15),
        fontWeight: Font.Weight? = .medium,
        cornerRadius: CGFloat = 4,
        horizontalPadding: CGFloat = 4,
        verticalPadding: CGFloat = 1,
        iconName: String = "link.circle.fill"
    ) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.fontWeight = fontWeight
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.iconName = iconName
    }
}
