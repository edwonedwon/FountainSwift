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
            print(lexer.count)
            switch lexer.count {
            case 1: // other types only have 1 line
                switch text.isAllUppercased {
                case true: // is all uppercased
                    result += [
                        .sceneHeading(text)
                    ]
                default: // is not all uppercased
                    result += [
                        .action(text)
                    ]
                }

            case 2: // dialogue always has 2 lines (character name + dialogue seperated by \n)
                let characterText = lexer.atIndex(0)
                let dialogueText = lexer.atIndex(1)
                var dialogue: Dialogue
                if (characterText != nil && dialogueText != nil) {
                    dialogue = Dialogue(character: characterText!, dialogue: dialogueText!)
                    result += [
                        .dialogue(dialogue)
                    ]
                    lexer.next() // just skip index because we used 2 lines already
                }
            default:
                print("nothing for: \(text)")
            }
        }
        return result
    }
    

}

extension String {
    var isAllUppercased: Bool {
        let capitalLetterRegEx  = "[A-Z]+"
        let test = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = test.evaluate(with: self)
        return capitalresult
    }
}
