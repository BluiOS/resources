// The Swift Programming Language
// https://docs.swift.org/swift-book

import Ccmark

public func markdownToHTML(input: String) -> String {
    let outString = cmark_markdown_to_html(input, input.utf8.count, 0)!
    defer { free(outString) }
    return String(cString: outString)
}

public class Node {
    let node: OpaquePointer

    var type: cmark_node_type {
        cmark_node_get_type(node)
    }

    var children: [Node] {
        var result: [Node] = []
        var child = cmark_node_first_child(node) 
        while let unwrapped = child {
            result.append(Node(node: unwrapped))
            child = cmark_node_next(child) }
        return result
    }

    var listType: cmark_list_type {
        get { return cmark_node_get_list_type(node) } 
        set { cmark_node_set_list_type(node, newValue) }
    }

    public init(node: OpaquePointer!) {
        self.node = node
    }

    public init(markdown: String) {
        let node = cmark_parse_document(markdown, markdown.utf8.count, 0)! 
        self.node = node
    }

    deinit {
        guard type == CMARK_NODE_DOCUMENT else { return }
        cmark_node_free(node)
    }
}

public enum Inline { 
    case text(text: String)
    case softBreak
    case lineBreak
    case code(text: String)
    case html(text: String)
    case emphasis(children: [Inline])
    case strong(children: [Inline])
    case custom(literal: String)
    case link(children: [Inline], title: String?, url: String) 
    case image(children: [Inline], title: String?, url: String)
}

public enum Block {
    case list(items: [[Block]], type: ListType)
    case blockQuote(items: [Block])
    case codeBlock(text: String, language: String?)
    case html(text: String)
    case paragraph(text: [Inline])
    case heading(text: [Inline], level: Int)
    case custom(literal: String)
    case thematicBreak
}

public enum ListType { 
    case unordered
    case ordered
}

let markdown = "*Hello World*"
let cString = cmark_markdown_to_html(markdown, markdown.utf8.count, 0)! 

defer { free(cString) }

let html = String(cString: cString)
print(html)

let html2 = markdownToHTML(input: markdown)
print(html)
