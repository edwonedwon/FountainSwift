//
//  File.swift
//  
//
//  Created by Edwon on 6/22/21.
//

import Foundation

class MarkdownParser {
    private let text: String
    
    init(text: String) {
        self.text = text
    }
    
    func parse() -> [MarkdownNode] {
        return []
    }
}

enum MarkdownNode: Equatable {}
