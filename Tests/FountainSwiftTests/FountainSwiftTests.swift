    import XCTest
    @testable import FountainSwift

    final class FountainSwiftTests: XCTestCase {
        func testParsing_sceneHeading_action() {
            let text = """
            INT. HOUSE - DAY
            
            poo action
            
            !INT. THIS IS ACTUALLY AN ACTION
            
            dipe action
            
            .forced scene heading
            
            some action
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .sceneHeading("INT. HOUSE - DAY"),
                .action("poo action"),
                .action("INT. THIS IS ACTUALLY AN ACTION"),
                .action("dipe action"),
                .sceneHeading("forced scene heading"),
                .action("some action"),
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
        
        func testParsing_character_dual_dialogue() {
            let text = """
            BRICK
            Sup?

            STEEL^
            They're coming out of the woodwork!
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .character("BRICK"),
                .dialogue("Sup?"),
                .characterDualDialogue("STEEL"),
                .dialogue("They're coming out of the woodwork!"),
            ])
        }
        
        func testParsing_lyrics() {
            let text = """
            ~Willy Wonka! Willy Wonka! The amazing chocolatier!
            ~Willy Wonka! Willy Wonka! Everybody give a cheer!
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .lyric("Willy Wonka! Willy Wonka! The amazing chocolatier!"),
                .lyric("Willy Wonka! Willy Wonka! Everybody give a cheer!"),
            ])
        }
        
        func testParsing_sceneTransition() {
            let text = """
            
            INT. POOPY HOUSE
            
            the dog sits
            
            CUT TO:
            
            > Burn to White.
            
            .CUT TO:
            
            BILL
            poo
            
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .sceneHeading("INT. POOPY HOUSE"),
                .action("the dog sits"),
                .transition("CUT TO:"),
                .transition("Burn to White."),
                .sceneHeading("CUT TO:"),
                .character("BILL"),
                .dialogue("poo"),
            ])
        }
    }
