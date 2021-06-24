//
//  File.swift
//  
//
//  Created by Edwon on 6/22/21.
//

import Foundation

class FountainBlockParser {
    private let block: String
    private let lexer: Lexer?
    private var titlePage: [TitlePageNode] = []
    private var onStartBoneyard: () -> Void
    private var onEndBoneyard: () -> Void

    init(_ block: String, onStartBoneyard: @escaping ()->Void, onEndBoneyard: @escaping ()->Void ) {
        self.block = block
        self.onStartBoneyard = onStartBoneyard
        self.onEndBoneyard = onEndBoneyard
        lexer = Lexer(raw: block, separator: "\n")
    }

    func parse() -> [FountainNode] {
        guard let lexer = lexer else {
            return []
        }
        var result: [FountainNode] = []
        
        var thisLexer = lexer
        if let newBlock = boneyardRemover(block) {
            print("new block: \(newBlock)")
            if (newBlock.isEmpty) {
                return []
            }
            thisLexer = Lexer(raw: newBlock, separator: "\n")!
        }
        
        while let line = thisLexer.next() {
//            print("lexer index: \(lexer.Index)")
//            print("lexer count: \(lexer.count)")
//            print("block: \(block)")
            print("line: \(line)")
                        
            // title page node
            if let node = isTitlePageNode(line) {
                titlePage += [node]
                continue
            } else if (hasTitlePagePrefix(line)) {
                continue
            }
            
            // page break
            if (isPageBreak(line)) {
                result += [.pageBreak]
                continue
            }
            
            // section
            if let node = isSection(line) {
                result += [.section(node)]
                continue
            }
            
            // snyopses
            if let node = isSynopses(line) {
                result += [.synopses(node)]
                continue
            }
            
            // note
            if let node = isNote(line) {
                result += [.note(NoteNode(node))]
                continue
            }
            
            // action - forced with ! check
            if let val = isAction(line) {
                result += [.action(val)]
                continue
            }
            
            // lyric - must come before character and dialogue
            if let val = isLyric(line) {
                result += [.lyric(val)]
                continue
            }
            
            // centered text - must come before character and dialogue
            if let val = isCenteredText(line) {
                result += [.centeredText(val)]
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
            
            if let val = isTransition(line) {
                result += [.transition(val)]
                continue
            }
            
            if let val = isParanthetical(line) {
                result += [.parenthetical(val)]
                continue
            }
            
            // action - by default make it an action - KEEP AT END
            result += [.action(line)]
        }
        
        // insert the title page at the beginning if there is one
        if (titlePage != []) {
            result.insert(.titlePage(titlePage), at: 0)
        }
        
        return result
    }
    
    func boneyardRemover(_ block: String) -> String? {
        if (block.contains("/*") && block.contains("*/")) {
            if let withoutBoneyard = block.removeSlice(from: "/*", to: "*/", alsoRemoveFromTo: true) {
                return withoutBoneyard
            }
        } else if (block.contains("/*")) {
//            print("boneyard started only")
//            let newBlock = block.remove
        } else if (block.contains("*/")) {
//            print("boneyard ended only")
        }
        return nil
    }
    
    func isTitlePageNode(_ line: String) -> TitlePageNode? {
        // if has a title key
        if hasTitlePagePrefix(line) {
            if let node = getTitlePageNode(line) {
                return node
            }
        // else if a line following a title page key
        } else {
            var previousLineIndex = lexer!.Index - 2
            while (previousLineIndex >= 0) {
                if let previousLine = lexer!.atIndex(previousLineIndex) {
                    if (hasTitlePagePrefix(previousLine)) {
                        var key = stringBeforeCharacter(previousLine, ":")
                        key = key.withoutSpaces
                        let value = line.withoutSpaces
                        return getTitlePageNode(key, value)
                    }
                }
                previousLineIndex -= 1
            }
        }
        return nil
    }
    
    func getTitlePageNode(_ line: String) -> TitlePageNode? {
        var key = stringBeforeCharacter(line, ":")
        var value = stringAfterCharacter(line, ":")
        if (value.isEmpty) { return nil }
        key = key.withoutSpaces
        value = value.withoutSpaces
        return getTitlePageNode(key, value)
    }
    
    func getTitlePageNode(_ key: String, _ value: String) -> TitlePageNode? {
        let key = key.lowercased()
        switch key {
        case "title":
            return .title(value)
        case "credit":
            return .credit(value)
        case "author":
            return .author(value)
        case "source":
            return .source(value)
        case "draft date":
            return .draftDate(value)
        case "contact":
            return .contact(value)
        default:
            return nil
        }
    }
    
    func hasTitlePagePrefix(_ line: String) -> Bool {
        let line = line.withoutSpaces
        if titlePagePrefixes.contains(where: line.hasPrefix) {
            return true
        }
        return false
    }
    
    func isSceneHeading(_ line: String) -> String? {
        if (isBlockMultiline()) { return nil }
        
        var lineWithoutSpaces = line.withoutSpaces
        if (lineWithoutSpaces.hasPrefix(".")) {
            lineWithoutSpaces.removeFirst()
            return lineWithoutSpaces
        }
        
        if sceneHeadingPrefixes.contains(where: line.hasPrefix) {
            return line
        }
        return nil
    }
    
    func isAction(_ line: String) -> String? {
        if (line.hasPrefix("!")){
            var str = line
            str.removeFirst(1)
            return str
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
        
        let characterName = stringBeforeCharacter(line, "(")
        if (characterName.count > 0) {
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
        let line = line.withoutSpaces
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
        let line = line.withoutSpaces
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
    
    func isTransition(_ line: String) -> String? {
        var lineWithoutSpaces = line.withoutSpaces
        if (lineWithoutSpaces.first == ">") {
            lineWithoutSpaces.removeFirst()
            lineWithoutSpaces = lineWithoutSpaces.withoutSpaces
            return lineWithoutSpaces
        }
        
        if (isBlockMultiline()) { return nil }
        
        if (line.hasSuffix("TO:")) {
            return lineWithoutSpaces
        }
        
        return nil
    }
    
    func isCenteredText(_ line: String) -> String? {
        var str = line.withoutSpaces
        if (str.hasPrefix(">") && str.hasSuffix("<")) {
            str.removeFirst()
            str.removeLast()
            str = str.withoutSpaces
            return str
        }
        return nil
    }
    
    func isPageBreak(_ line: String) -> Bool {
        let line = line.withoutSpaces
        var isAllEquals = true
        for c in line {
            if (c != "=") {
                isAllEquals = false
            }
        }
        return isAllEquals
    }
    
    func isSection(_ line: String) -> SectionNode? {
        let line = line.withoutSpaces
        if (line.hasPrefix("#")) {
            var totalEquals = 0
            for c in line {
                if (c == "#") {
                    totalEquals += 1
                } else {
                    break
                }
            }
            let lineWithoutSpaces = line.withoutSpaces
            let index = lineWithoutSpaces.index(lineWithoutSpaces.startIndex, offsetBy: totalEquals)
            let lineWithoutSectionMarkers = String(lineWithoutSpaces[index...]) // Hello
            let finalLine = lineWithoutSectionMarkers.withoutSpaces
            return SectionNode(finalLine, totalEquals-1)
        }
        return nil
    }
    
    func isSynopses(_ line: String) -> String? {
        var line = line.withoutSpaces
        if (line.hasPrefix("=")) {
            line.removeFirst()
            return line.withoutSpaces
        }
        return nil
    }
    
    func isNote(_ line: String) -> String? {
        var line = line.withoutSpaces
        if (line.hasPrefix("[[") && line.hasSuffix("]]")) {
            line.removeFirst()
            line.removeFirst()
            line.removeLast()
            line.removeLast()
            return line.withoutSpaces
        }
        return nil
    }
    
    func isBlockMultiline() -> Bool {
        if (lexer!.count > 1) {
            return true
        }
        return false
    }
    
    func stringBeforeCharacter(_ str: String,_ separator: String) -> String {
        let stringBeforeChar = str.components(separatedBy: separator)
        return stringBeforeChar[0]
    }
    
    func stringAfterCharacter(_ str: String,_ separator: String) -> String {
        let stringAfterChar = str.components(separatedBy: separator)
        return stringAfterChar[1]
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
    
    // removes spaces form beginning and end of string
    // but leaves spaces between characters
    var withoutSpaces: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func removeSlice(from: String, to: String, alsoRemoveFromTo: Bool) -> String? {
        var newString = self
        if (alsoRemoveFromTo) {
            guard let rangeFrom = range(of: from)?.lowerBound else { return nil }
            guard let rangeTo = self[rangeFrom...].range(of: to)?.upperBound else { return nil }
            let range = rangeFrom..<rangeTo
            newString.removeSubrange(range)
        } else {
            guard let rangeFrom = range(of: from)?.upperBound else { return nil }
            guard let rangeTo = self[rangeFrom...].range(of: to)?.lowerBound else { return nil }
            let range = rangeFrom..<rangeTo
            newString.removeSubrange(range)
        }
        return newString
    }
}
