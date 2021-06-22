//
//  File.swift
//  
//
//  Created by Edwon on 6/22/21.
//

import Foundation

class MarkdownParser {
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    func parse() -> [MarkdownNode] {
        // in case text is empty, return empty sequence instead of any nodes
        guard !text.isEmpty, let lexer = Lexer(raw: text, separator: "\n\n") else {
            return []
        }
        var result: [MarkdownNode] = []
        // iterate the lexems/blocks until there are no more available
        while let block = lexer.next() {
            result += BlockParser(block).parse()
        }
        return result
    }
}

enum MarkdownNode: Equatable {
    case paragraph(nodes: [MarkdownNode])
    case text(String)
    case bold(String)
}
