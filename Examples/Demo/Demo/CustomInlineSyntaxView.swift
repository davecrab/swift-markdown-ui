import SwiftUI
import MarkdownUI

struct CustomInlineSyntaxView: View {
    private let markdownContent = #"""
    ## Custom Inline Syntax Demo

    This demonstrates the custom inline syntax for citations and artifact references.

    Here is a citation to the first source [1]. We can reference it multiple times [1].

    The second source is mentioned here [2].

    Let's also link an artifact: @[Important Document](artifact:123e4567-e89b-12d3-a456-426614174000). You can include artifacts within **bold text** like @[Spec Sheet](artifact:spec-abc-def) or *emphasized text* like @[User Guide](artifact:user-guide-xyz).

    Citations and artifacts can appear mid-sentence, like this [3], or at the end @[Final Report](artifact:report-final-001).

    Attempting an out-of-bounds citation [4] should render but might not be interactive if no URL is provided.
    """#

    // Define URLs as optionals for convenience in initialization
    private let sampleCitationURLs: [URL?] = [
        URL(string: "https://www.example.com/source/1"), // For [1]
        URL(string: "https://www.example.com/source/2"), // For [2]
        URL(string: "https://www.example.com/source/3"),  // For [3]
        nil // Explicitly nil for [4] to show handling of missing citations
    ]
    
    // Computed property that filters out nil values for the environment
    private var nonNilCitationURLs: [URL] {
        sampleCitationURLs.compactMap { $0 }
    }
    
    @State private var selectedTheme = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("Theme Style", selection: $selectedTheme) {
                Text("Default").tag(0)
                Text("Modern").tag(1)
                Text("Colorful").tag(2)
                Text("Minimal").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            ScrollView {
                Group {
                    switch selectedTheme {
                    case 0:
                        // Default theme
                        Markdown(markdownContent)
                            .markdownTheme(.gitHub)
                    case 1:
                        // Modern theme
                        Markdown(markdownContent)
                            .markdownTheme { theme in
                                var newTheme = theme
                                newTheme.citation = CitationStyle(
                                    foregroundColor: .white,
                                    backgroundColor: .indigo,
                                    fontWeight: .bold,
                                    cornerRadius: 6,
                                    horizontalPadding: 6,
                                    verticalPadding: 2
                                )
                                newTheme.artifactReference = ArtifactReferenceStyle(
                                    foregroundColor: .teal,
                                    backgroundColor: .teal.opacity(0.15),
                                    fontWeight: .semibold,
                                    cornerRadius: 6,
                                    horizontalPadding: 6,
                                    verticalPadding: 2,
                                    iconName: "doc.badge"
                                )
                                return newTheme
                            }
                    case 2:
                        // Colorful theme
                        Markdown(markdownContent)
                            .markdownTheme { theme in
                                var newTheme = theme
                                newTheme.citation = CitationStyle(
                                    foregroundColor: .white,
                                    backgroundColor: .red.opacity(0.8),
                                    fontWeight: .heavy,
                                    cornerRadius: 8,
                                    horizontalPadding: 8,
                                    verticalPadding: 3
                                )
                                newTheme.artifactReference = ArtifactReferenceStyle(
                                    foregroundColor: .yellow,
                                    backgroundColor: .orange.opacity(0.2),
                                    fontWeight: .bold,
                                    cornerRadius: 8,
                                    horizontalPadding: 8,
                                    verticalPadding: 3,
                                    iconName: "star.fill"
                                )
                                return newTheme
                            }
                    case 3:
                        // Minimal theme
                        Markdown(markdownContent)
                            .markdownTheme { theme in
                                var newTheme = theme
                                newTheme.citation = CitationStyle(
                                    foregroundColor: .primary,
                                    backgroundColor: .clear,
                                    fontWeight: .regular,
                                    cornerRadius: 0,
                                    horizontalPadding: 2,
                                    verticalPadding: 0
                                )
                                newTheme.artifactReference = ArtifactReferenceStyle(
                                    foregroundColor: .secondary,
                                    backgroundColor: .clear,
                                    fontWeight: .regular,
                                    cornerRadius: 0,
                                    horizontalPadding: 2,
                                    verticalPadding: 0,
                                    iconName: "link"
                                )
                                return newTheme
                            }
                    default:
                        Markdown(markdownContent)
                    }
                }
                .padding()
                .environment(\.citationURLs, nonNilCitationURLs)
            }
        }
        .navigationTitle("Custom Syntax")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CustomInlineSyntaxView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CustomInlineSyntaxView()
        }
    }
}
