//
//  File.swift
//  
//
//  Created by Edwon on 6/22/21.
//

import Foundation

class BlockParser {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    func parse() -> [MarkdownNode] {
        guard let lexer = Lexer(raw: text, separator: "\n") else {
            return []
        }
        var result: [MarkdownNode] = []
        while let fragment = lexer.next() {
            // leave this node here for now, so our original tests dont fail
            result += [
                .text(text)
            ]
        }
        return result
    }
}
