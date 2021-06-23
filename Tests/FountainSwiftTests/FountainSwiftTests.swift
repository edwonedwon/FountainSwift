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
        
        func testParsing_character_dialogue() {
            let text = """
            BRICK (O. S.)
            I'm saying a thing!
            
                BRICK
            Poopy DOOOOPYYYY.
            
              BRICK
            This is so fun!
            
            HANS (on the radio)
            What the fuck?!!
            
            @McCLANE
            Freeedoooommmm!!!!
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .character("BRICK (O. S.)"),
                .dialogue("I'm saying a thing!"),
                .character("BRICK"),
                .dialogue("Poopy DOOOOPYYYY."),
                .character("BRICK"),
                .dialogue("This is so fun!"),
                .character("HANS (on the radio)"),
                .dialogue("What the fuck?!!"),
                .character("McCLANE"),
                .dialogue("Freeedoooommmm!!!!"),
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
    }
