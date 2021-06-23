//
//  File.swift
//  
//
//  Created by Edwon on 6/22/21.
//

import Foundation

class FountainBlockParser {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    func parse() -> [FountainNode] {
        guard let lexer = Lexer(raw: text, separator: "\n") else {
            return []
        }
        var result: [FountainNode] = []
        while var text = lexer.next() {
            // action - forced with ! check
            if (text.hasPrefix("!")){
                text.removeFirst(1)
                result += [
                    .sceneHeading(text)
                ]
                continue
            }
            
            // scene heading - if it has one of the prefixes
            if sceneHeadingPrefixes.contains(where: text.hasPrefix) {
                result += [
                    .sceneHeading(text)
                ]
                continue
            }
            
            // action - anything else should be an action
            result += [
                .action(text)
            ]
        }
        return result
    }
    
    let sceneHeadingPrefixes = [
        "INT ",
        "EXT ",
        "EST ",
        "INT./EXT ",
        "INT/EXT ",
        "I/E ",
        "INT.",
        "EXT.",
        "EST.",
        "INT./EXT.",
        "INT/EXT.",
        "I/E.",
    ]
}

extension String {
    var isAllUppercased: Bool {
        let capitalLetterRegEx  = "[A-Z]+"
        let test = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = test.evaluate(with: self)
        return capitalresult
    }
}
