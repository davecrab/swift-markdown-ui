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

    private let sampleCitationURLs: [URL?] = [
        URL(string: "https://www.example.com/source/1"), // For [1]
        URL(string: "https://www.example.com/source/2"), // For [2]
        URL(string: "https://www.example.com/source/3")  // For [3]
        // No URL for [4]
    ]

    var body: some View {
        ScrollView {
            Markdown(markdownContent)
                .padding()
                .markdownTheme(.gitHub) // Use a standard theme
                .environment(\.citationURLs, sampleCitationURLs)
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
