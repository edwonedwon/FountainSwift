//
//  File.swift
//  
//
//  Created by Edwon on 6/22/21.
//

import Foundation

enum FountainNode: Equatable {
    case titlePage([TitlePageNode])
    case sceneHeading(String)
    case action(String)
    case character(String)
    case characterDualDialogue(String)
    case dialogue(String)
    case parenthetical(String)
    case lyric(String)
    case transition(String)
    case centeredText(String)
    case pageBreak
    case section(SectionNode)
    case synopses(String)
    case note(NoteNode)
}

struct NoteNode: Equatable {
    let text: String
    let locationInPreviousNode: Int?
    
    init(_ text: String) {
        self.text = text
        locationInPreviousNode = nil
    }
    
    init(_ text: String,_ locationInPreviousNode: Int?) {
        self.text = text
        self.locationInPreviousNode = locationInPreviousNode
    }
}

struct SectionNode: Equatable {
    let text: String
    let nestLevel: Int
    
    init (_ text: String,_ nestLevel: Int) {
        self.text = text
        self.nestLevel = nestLevel
    }
}

enum TitlePageNode: Equatable {
    case title(String)
    case credit(String)
    case author(String)
    case source(String)
    case contact(String)
    case draftDate(String)
}
