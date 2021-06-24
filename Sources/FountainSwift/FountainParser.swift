//
//  File.swift
//  
//
//  Created by Edwon on 6/22/21.
//

import Foundation

class FountainParser {
    private let text: String
    private var isBoneyardSpan = false
    
    init(_ text: String) {
        self.text = text
    }
    
    func parse() -> [FountainNode] {
        // in case text is empty, return empty sequence instead of any nodes
        guard !text.isEmpty, let lexer = Lexer(raw: text, separator: "\n\n") else {
            return []
        }
        var result: [FountainNode] = []
        // iterate the lexems/blocks until there are no more available
        while let text = lexer.next() {
            let resultToAdd = FountainBlockParser(text,
            onStartBoneyard: {
                self.isBoneyardSpan = true
            }, onEndBoneyard: {
                self.isBoneyardSpan = false
            }).parse()
            
            if (!isBoneyardSpan) {
                result += resultToAdd
            }
        }
        return result
    }
}
