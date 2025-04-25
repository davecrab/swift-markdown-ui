import SwiftUI

private struct CitationURLsKey: EnvironmentKey {
    static let defaultValue: [URL]? = nil
}

extension EnvironmentValues {
    /// The list of citation URLs available in the Markdown context.
    ///
    /// Use this environment value to provide the necessary URLs
    /// when rendering custom citation nodes.
    var citationURLs: [URL]? {
        get { self[CitationURLsKey.self] }
        set { self[CitationURLsKey.self] = newValue }
    }
}
