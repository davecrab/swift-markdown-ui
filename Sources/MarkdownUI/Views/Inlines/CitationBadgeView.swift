import SwiftUI

/// A view that displays a citation badge with an optional tap action to open a URL.
struct CitationBadgeView: View {
    let number: Int
    let url: URL?
    
    @Environment(\.theme) private var theme
    
    var body: some View {
        Text("[\(number)]")
            .font(.footnote)
            .fontWeight(theme.citation.fontWeight)
            .foregroundColor(theme.citation.foregroundColor)
            .padding(.horizontal, theme.citation.horizontalPadding)
            .padding(.vertical, theme.citation.verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: theme.citation.cornerRadius)
                    .fill(theme.citation.backgroundColor ?? Color.blue.opacity(0.8))
            )
            .onTapGesture {
                if let url = url {
                    #if os(macOS)
                    NSWorkspace.shared.open(url)
                    #elseif os(iOS) || os(tvOS)
                    UIApplication.shared.open(url)
                    #endif
                }
            }
    }
}

/// A view that displays an artifact reference with an optional tap action.
struct ArtifactReferenceView: View {
    let title: String
    let uuid: String
    
    @Environment(\.theme) private var theme
    
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: theme.artifactReference.iconName)
                .font(.footnote)
            Text(title)
                .fontWeight(theme.artifactReference.fontWeight)
        }
        .foregroundColor(theme.artifactReference.foregroundColor)
        .padding(.horizontal, theme.artifactReference.horizontalPadding)
        .padding(.vertical, theme.artifactReference.verticalPadding)
        .background(
            RoundedRectangle(cornerRadius: theme.artifactReference.cornerRadius)
                .fill(theme.artifactReference.backgroundColor ?? Color.purple.opacity(0.15))
        )
        // Add tap gesture if needed for artifact interaction
        .onTapGesture {
            // Handle artifact tap - could dispatch to a handler via environment
            print("Artifact tapped: \(uuid)")
        }
    }
}

#if DEBUG
struct CitationBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CitationBadgeView(number: 1, url: URL(string: "https://example.com"))
            CitationBadgeView(number: 42, url: nil)
            ArtifactReferenceView(title: "Design Document", uuid: "doc-123")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
