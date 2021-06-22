//
//  File.swift
//  
//
//  Created by Edwon on 6/22/21.
//

import Foundation

enum FountainNode: Equatable {
//    // temp
//    case text(String)
    
    case sceneHeading(String)
    case action(String)
    case dialogue(Dialogue)
}

struct Dialogue: Equatable {
    var character: String
    var dialogue: String
}
