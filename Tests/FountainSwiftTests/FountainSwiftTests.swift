    import XCTest
    @testable import FountainSwift

    final class FountainSwiftTests: XCTestCase {
        func testParsing_sceneHeading() {
            let text = """
            INT. HOUSE - DAY
            
            poo action
            
            !INT. HOUSE - DAY
            
            dipe action
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .sceneHeading("INT. HOUSE - DAY"),
                .action("poo action"),
                .sceneHeading("INT. HOUSE - DAY"),
                .action("dipe action")
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
