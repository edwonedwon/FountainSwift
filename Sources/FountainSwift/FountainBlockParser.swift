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
        while let text = lexer.next() {
            // action - forced with ! check
            if let val = text.isAction {
                result += [.action(val)]
                continue
            }
            
            // scene heading - if it has one of the prefixes
            if let val = text.isSceneHeading {
                result += [.sceneHeading(val)]
                continue
            }
            
            // parenthetical - if it follows character or dialogue and is wrapped in parentheses
//            if (text.hasPrefix("(") && text.hasSuffix(")")){
//
//            }
            
            // KEEP AT END action - anything else should be an action
            result += [
                .action(text)
            ]
        }
        return result
    }
}

extension String {
    var isAction: String? {
        if (self.hasPrefix("!")){
            var text = self
            text.removeFirst(1)
            return text
        }
        return nil
    }
    
    var isSceneHeading: String? {
        if sceneHeadingPrefixes.contains(where: self.hasPrefix) {
            return self
        }
        return nil
    }
    
    var isAllUppercased: Bool {
        let capitalLetterRegEx  = "[A-Z]+"
        let test = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = test.evaluate(with: self)
        return capitalresult
    }
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
