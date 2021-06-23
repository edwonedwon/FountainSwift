//
//  File.swift
//  
//
//  Created by Edwon on 6/22/21.
//

import Foundation

enum FountainNode: Equatable { 
    case sceneHeading(String)
    case action(String)
    case character(String)
    case characterDualDialogue(String)
    case dialogue(String)
    case parenthetical(String)
    case lyric(String)
    case transition(String)
    case centeredText(String)
}
