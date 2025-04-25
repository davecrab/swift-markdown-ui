import SwiftUI

struct InlineText: View {
  @Environment(\.inlineImageProvider) private var inlineImageProvider
  @Environment(\.baseURL) private var baseURL
  @Environment(\.imageBaseURL) private var imageBaseURL
  @Environment(\.softBreakMode) private var softBreakMode
  @Environment(\.theme) private var theme
  @Environment(\.citationURLs) private var citationURLs

  private let inlines: [InlineNode]

  init(_ inlines: [InlineNode]) {
    self.inlines = inlines.filter { node in
        if case .text(let str) = node, str.isEmpty { return false }
        return true
    }
  }

  var body: some View {
    TextStyleAttributesReader { attributes in
        inlines.reduce(Text("")) { partialResult, node in
            partialResult + renderNodeAsText(node, attributes: attributes)
        }
    }
  }

  // MARK: - Rendering Helpers

  private func renderNodeAsText(_ node: InlineNode, attributes: AttributeContainer) -> Text {
    switch node {
    case .text(let string):
        if string.range(of: "(\\[\\d+\\])|(@\\[(.+?)\\]\\\(artifact:([a-fA-F0-9\\-]+)\\\\))", options: .regularExpression) != nil {
             return renderTextWithCustomSyntaxAsText(string, attributes: attributes)
        } else {
             return renderStandardInline(node, attributes: attributes)
        }

    case .citation(let number):
        return Text("[\(number)]")
            .foregroundColor(.blue)
            .underline()
            // If CitationBadgeView conforms to InlineView, Text(...) might work

    case .artifactReference(let title, let uuid):
        return Text("🔗 \(title)")
            .foregroundColor(.purple)
            // If ArtifactReference conforms ..., Text(...) might work

    case .strong(let children):
        return renderInlineSequenceAsText(children, attributes: attributes).bold()

    case .emphasis(let children):
        return renderInlineSequenceAsText(children, attributes: attributes).italic()

    case .strikethrough(let children):
        return renderInlineSequenceAsText(children, attributes: attributes).strikethrough()

    case .link(let destination, let children):
        let content = renderInlineSequenceAsText(children, attributes: attributes)
        if let url = URL(string: destination, relativeTo: baseURL) {
            return content.underline().foregroundColor(theme.link.foregroundColor ?? .accentColor)
                       .onTapGesture { OpenURLAction { _ in .handled }.callAsFunction(url) }
        } else {
            return content
        }

    case .code(let string):
        return renderStandardInline(node, attributes: attributes)

    case .image(let source, _):
        return Text("[Image: \(source)]").font(.caption).foregroundColor(.gray)
        // Or attempt rendering via renderStandardInline if it handles images
        // return renderStandardInline(node, attributes: attributes)

    case .softBreak:
        return Text(self.softBreakMode == .space ? " " : "\n")

    case .lineBreak:
        return Text("\n")

    case .html(let string): 
        return renderStandardInline(node, attributes: attributes)

    // Default fallback (should ideally not be reached if all cases are handled)
    // default:
    //     return Text(node.renderPlainText()) 
    }
  }

  private func renderStandardInline(_ node: InlineNode, attributes: AttributeContainer) -> Text {
     Text(node.renderAttributedString(
          baseURL: self.baseURL,
          textStyles: self.textStylesFromTheme(),
          softBreakMode: self.softBreakMode,
          attributes: attributes
     ))
  }

  private func renderInlineSequenceAsText(_ nodes: [InlineNode], attributes: AttributeContainer) -> Text {
    nodes.reduce(Text("")) { partialResult, node in
        partialResult + renderNodeAsText(node, attributes: attributes)
    }
  }

  private func renderTextWithCustomSyntaxAsText(_ text: String, attributes: AttributeContainer) -> Text {
    let pattern = "(\\[\\d+\\])|(@\\[(.+?)\\]\\\(artifact:([a-fA-F0-9\\-]+)\\\\))"
    let regex = try! NSRegularExpression(pattern: pattern)
    var lastIndex = text.startIndex
    var combinedText = Text("")
    let baseText = renderStandardInline(.text(""), attributes: attributes) 

    regex.matches(in: text, range: NSRange(text.startIndex..., in: text)).forEach { match in
        let matchRange = Range(match.range, in: text)!
        if lastIndex < matchRange.lowerBound {
            combinedText = combinedText + baseText + Text(String(text[lastIndex..<matchRange.lowerBound]))
        }

        if let citationRange = Range(match.range(at: 1), in: text),
           let n = Int(text[citationRange].dropFirst().dropLast()) {
            combinedText = combinedText + renderNodeAsText(.citation(number: n), attributes: attributes)
        } else if let titleRange = Range(match.range(at: 3), in: text),
                  let uuidRange = Range(match.range(at: 4), in: text) {
            combinedText = combinedText + renderNodeAsText(.artifactReference(title: String(text[titleRange]), uuid: String(text[uuidRange])), attributes: attributes)
        }
        lastIndex = matchRange.upperBound
    }

    if lastIndex < text.endIndex {
        combinedText = combinedText + baseText + Text(String(text[lastIndex...]))
    }

    return combinedText
  }

  private func textStylesFromTheme() -> InlineTextStyles {
    .init(
        code: self.theme.code,
        emphasis: self.theme.emphasis,
        strong: self.theme.strong,
        strikethrough: self.theme.strikethrough,
        link: self.theme.link
    )
  }

  private func citationURL(for number: Int) -> URL? {
    guard let urls = citationURLs, urls.indices.contains(number - 1) else {
        return nil
    }
    return urls[number - 1]
  }
}
