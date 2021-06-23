//
//  File.swift
//  
//
//  Created by Edwon on 6/22/21.
//

import Foundation

class FountainBlockParser {
    let block: String
    let lexer: Lexer?

    init(_ block: String) {
        self.block = block
        lexer = Lexer(raw: block, separator: "\n")
    }

    func parse() -> [FountainNode] {
        guard let lexer = lexer else {
            return []
        }
        var result: [FountainNode] = []
        while let line = lexer.next() {
//            print("lexer index: \(lexer.Index)")
//            print("lexer count: \(lexer.count)")
//            print("block: \(block)")
//            print("line: \(line)")
            
            // action - forced with ! check
            if let val = isAction(line) {
                result += [.action(val)]
                continue
            }
            
            if let val = isLyric(line) {
                result += [.lyric(val)]
                continue
            }
            
            if let val = isSceneHeading(line) {
                result += [.sceneHeading(val)]
                continue
            }
            
            if let val = isCharacter(line) {
                result += [.character(val)]
                continue
            }
            
            if let val = isCharacterDualDialogue(line) {
                result += [.characterDualDialogue(val)]
                continue
            }
            
            if let val = isDialogue(line) {
                result += [.dialogue(val)]
                continue
            }
            
            if let val = isParanthetical(line) {
                result += [.parenthetical(val)]
                continue
            }
            
            // KEEP AT END action - anything else should be an action
            result += [.action(line)]
        }
        return result
    }
    
    func isAction(_ line: String) -> String? {
        if (line.hasPrefix("!")){
            var str = line
            str.removeFirst(1)
            return str
        }
        return nil
    }
    
    func isSceneHeading(_ line: String) -> String? {
        if sceneHeadingPrefixes.contains(where: line.hasPrefix) {
            return line
        }
        return nil
    }
    
    func isCharacter(_ line: String) -> String? {
        if (!isBlockMultiline()) { return nil }
        if (lexer!.Index != 1) { return nil }
        
        if (line.first == "@") {
            var str = line
            str.removeFirst()
            return str
        }
        
        let delimiter = "("
        let token = line.components(separatedBy: delimiter)
        if (token.count > 0) {
            let characterName = token[0]
            if (characterName.isAllUppercased) {
                return line.withoutSpaces
            }
        }
        
        if (line.isAllUppercased) {
            return line
        }
        return nil
    }
    
    func isCharacterDualDialogue(_ line: String) -> String? {
        var lineWithoutSpaces = line.withoutSpaces
        if (lineWithoutSpaces.hasSuffix("^")) {
            lineWithoutSpaces.removeLast()
            if let characterLine = isCharacter(lineWithoutSpaces) {
                return characterLine
            }
        }
        return nil
    }
    
    func isDialogue(_ line: String) -> String? {
        if (isBlockMultiline()) {
            if (lexer!.Index >= 2) {
                if (isParanthetical(line) == nil) {
                    return line
                }
            }
        }
        return nil
    }
    
    func isParanthetical(_ line: String) -> String? {
        if (line.hasPrefix("(") && line.hasSuffix(")")) {
            if (lexer!.Index != 1) {
                var str = line
                str.removeFirst()
                str.removeLast()
                return str
            }
        }
        return nil
    }
    
    func isLyric(_ line: String) -> String? {
        if (line.hasPrefix("~")) {
            var str = line
            str.removeFirst()
            return str
        }
        return nil
    }
    
    func isBlockMultiline() -> Bool {
        if (lexer!.count > 1) {
            return true
        }
        return false
    }
}

extension String {
    var isAllUppercased: Bool {
        let capitalLetterRegEx  = "[A-Z]+"
        let test = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let str = self.withoutSpaces
        let capitalresult = test.evaluate(with: str)
        return capitalresult
    }
    
    var withoutSpaces: String {
        return self.trimmingCharacters(in: .whitespaces)
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
