//
//  File.swift
//  
//
//  Created by Edwon on 6/22/21.
//

import Foundation

class FountainBlockParser {
    let text: String

    init(text: String) {
        self.text = text
    }

    func parse() -> [FountainNode] {
        guard let lexer = Lexer(raw: text, separator: "\n") else {
            return []
        }
        var result: [FountainNode] = []
        while let blockText = lexer.next() {
            // Leave this node here for now, so our original test cases are not failing
            result += [
                .text(blockText)
            ]
        }
        return result
    }
}
