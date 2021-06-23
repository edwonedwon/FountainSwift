    import XCTest
    @testable import FountainSwift

    final class FountainSwiftTests: XCTestCase {
        
        func testParsing_sceneHeading_action() {
            let text = """
            INT. HOUSE - DAY
            
            poo action
            
            !INT. THIS IS ACTUALLY AN ACTION
            
            dipe action
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .sceneHeading("INT. HOUSE - DAY"),
                .action("poo action"),
                .action("INT. THIS IS ACTUALLY AN ACTION"),
                .action("dipe action"),
            ])
        }
        
        func testParsing_character() {
            let text = """
            BRICK (O. S.)
            dialogue
            
                BRICK
            dialogue
            
              BRICK
            dialogue
            
            HANS (on the radio)
            dialogue
            
            @McCLANE
            dialogue
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .character("BRICK (O. S.)"),
                .dialogue("dialogue"),
                .character("BRICK"),
                .dialogue("dialogue"),
                .character("BRICK"),
                .dialogue("dialogue"),
                .character("HANS (on the radio)"),
                .dialogue("dialogue"),
                .character("McCLANE"),
                .dialogue("dialogue"),
            ])
        }
        
        func testParsing_character_dialogue() {
            let text = """
            BRICK
            Sup?
            
            JIMMY
            Hey
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .character("BRICK"),
                .dialogue("Sup?"),
                .character("JIMMY"),
                .dialogue("Hey"),
            ])
        }
        
        func testParsing_character_dialogue_parentheticals() {
            let text = """
            BRICK
            Sup?

            STEEL
            They're coming out of the woodwork!
            (pause)
            No, everybody we've put away!
            (pause)
            Point Blank Sniper?
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .character("BRICK"),
                .dialogue("Sup?"),
                .character("STEEL"),
                .dialogue("They're coming out of the woodwork!"),
                .parenthetical("pause"),
                .dialogue("No, everybody we've put away!"),
                .parenthetical("pause"),
                .dialogue("Point Blank Sniper?"),
            ])
        }
        
//        func testParsing_simple() {
//            let text = """
//            EXT. BRICK'S PATIO - DAY
//
//            A gorgeous day.  The sun is shining.  But BRICK BRADDOCK, retired police detective, is sitting quietly, contemplating -- something.
//
//            The SCREEN DOOR slides open and DICK STEEL, his former partner and fellow retiree, emerges with two cold beers.
//
//            STEEL
//            Beer's ready!
//            """
//            let parser = FountainParser(text)
//            let nodes = parser.parse()
//            XCTAssertEqual(nodes, [
//                .sceneHeading("EXT. BRICK'S PATIO - DAY"),
//                .action("A gorgeous day.  The sun is shining.  But BRICK BRADDOCK, retired police detective, is sitting quietly, contemplating -- something."),
//                .action("The SCREEN DOOR slides open and DICK STEEL, his former partner and fellow retiree, emerges with two cold beers."),
//                .dialogue(Dialogue(character: "STEEL", dialogue: "Beer's ready!"))
//            ])
//        }
        
//        func testParsing_section() {
//            let text = """
//            # This is a section
//            """
//            let parser = FountainParser(text)
//            let nodes = parser.parse()
//            XCTAssertEqual(nodes, [
//                .
//            ])
//        }
//
//        func testParsing_everything() {
//            let text = """
//            # This is a section
//
//            = this is a synopses (which is basically a note, but could be used to summarize a scene)
//
//            EXT. HOUSE
//
//            A gorgeous day.  The sun is shining.
//
//            The SCREEN DOOR slides open.
//
//            !SCANNING THE AISLES...
//            Where is that pit boss?
//
//            No luck. He has no choice but to deal the cards.
//
//            ## This is a section within a section
//
//            JIMMY
//            Yo!
//
//            BRICK
//            Sup?
//
//            STEEL
//            They're coming out of the woodwork!
//            (pause)
//            No, everybody we've put away!
//            (pause)
//            Point Blank Sniper?
//
//            ===
//
//            STEEL
//            (beer raised)
//            To retirement.
//            """
//            let parser = FountainParser(text)
//            let nodes = parser.parse()
//            XCTAssertEqual(nodes, [
//                .sceneHeading("EXT. BRICK'S PATIO - DAY"),
//                .action("A gorgeous day.  The sun is shining.  But BRICK BRADDOCK, retired police detective, is sitting quietly, contemplating -- something."),
//                .action("The SCREEN DOOR slides open and DICK STEEL, his former partner and fellow retiree, emerges with two cold beers."),
//                .dialogue(Dialogue(character: "STEEL", dialogue: "Beer's ready!"))
//            ])
//        }
    }
