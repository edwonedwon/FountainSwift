//
//  File.swift
//  
//
//  Created by Edwon on 6/22/21.
//

import Foundation

/// separates a string of text into separate smaller strings
/// based on the "separator" given
class Lexer: IteratorProtocol {
    /// lexems to iterate
    private let lexems: [String]
    
    /// current iterator position
    private var index = 0
    
    /// creates a new lexer by tokenizing the given expression string.
    ///
    /// if the given expression is empty, or contains only empty characters (such as spaces)
    /// nil is returned, indicating no further parsing is necessary
    ///
    /// - Parameter expression: expression used to tokenize and lex
    convenience init?(raw expression: String, separator: String) {
        let lexems = expression.components(separatedBy: separator)
        guard !lexems.isEmpty else {
            return nil
        }
        self.init(lexems: lexems)
    }
    
    /// creates a new lexer for iterating the given lexems
    /// - Parameter lexems: Tokens to iterate
    init(lexems: [String]) {
        assert(!lexems.isEmpty, "Lexer should have at least one value")
        self.lexems = lexems
    }
    
    /// Returns the currently selected lexem, does not modify the cursor position
    var token: String {
        lexems[index]
    }
    
    /// Returns the total lexems
    var count: Int {
        lexems.count
    }
    
    func atIndex(_ index: Int) -> String? {
        if (index < count ) {
            return lexems[index]
        }
        return nil
    }
    
    /// Returns the currenttly selected lexem and moves the cursor to the next position
    func next() -> String? {
        guard !isAtEnd else {
            return nil
        }
        let token = lexems[index]
        index += 1
        return token
    }
    
    /// Returns truthy value if the end is reached, therefore all elements were iterated
    var isAtEnd: Bool {
        index >= lexems.count
    }
}
