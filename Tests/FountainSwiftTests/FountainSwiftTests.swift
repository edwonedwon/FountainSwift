    import XCTest
    @testable import FountainSwift

    final class FountainSwiftTests: XCTestCase {
        
        func testParsing_titlePage_easy() {
            let text = """
            Title: Star Wars
            Credit: Written by
            Author: George Lucas
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .titlePage([
                    .title("Star Wars"),
                    .credit("Written by"),
                    .author("George Lucas"),
                ])
            ])
        }
        
        func testParsing_titlePage_medium() {
            let text = """
            Title:
                _**BRICK & STEEL**_
                _**FULL RETIRED**_
            Credit: Written by
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .titlePage([
                    .title("_**BRICK & STEEL**_"),
                    .title("_**FULL RETIRED**_"),
                    .credit("Written by"),
                ])
            ])
        }
        
        func testParsing_titlePage_hard() {
            let text = """
            Title:
                _**BRICK & STEEL**_
                _**FULL RETIRED**_
            Credit: Written by
            Author: Stu Maschwitz
            Source: Story by KTM
            Draft date: 1/20/2012
            Contact:
                Next Level Productions
                1588 Mission Dr.
                Solvang, CA 93463
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .titlePage([
                    .title("_**BRICK & STEEL**_"),
                    .title("_**FULL RETIRED**_"),
                    .credit("Written by"),
                    .author("Stu Maschwitz"),
                    .source("Story by KTM"),
                    .draftDate("1/20/2012"),
                    .contact("Next Level Productions"),
                    .contact("1588 Mission Dr."),
                    .contact("Solvang, CA 93463"),
                ])
            ])
        }
        
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
        
        func testParsing_transition() {
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
        
        func testParsing_centeredText() {
            let text = """
            
            >THE END<
            >  THE END  <
            
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .centeredText("THE END"),
                .centeredText("THE END"),
            ])
        }
        
        func testParsing_pageBreak() {
            let text = """
            
            ===
            
            ===============
            
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .pageBreak,
                .pageBreak,
            ])
        }
        
        func testParsing_fullScript_medium() {
            let text = """
            
                        CUT TO:

            INT. GARAGE - DAY

            BRICK and STEEL get into Mom's PORSCHE, Steel at the wheel.  They pause for a beat, the gravity of the situation catching up with them.
            
                        ===============================================

                                BRICK
                        This is everybody we've ever put away.

                            STEEL
                           (starting the engine)
                        So much for retirement!

            They speed off.  To destiny!
            
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .transition("CUT TO:"),
                .sceneHeading("INT. GARAGE - DAY"),
                .action("BRICK and STEEL get into Mom's PORSCHE, Steel at the wheel.  They pause for a beat, the gravity of the situation catching up with them."),
                .pageBreak,
                .character("BRICK"),
                .dialogue("This is everybody we've ever put away."),
                .character("STEEL"),
                .parenthetical("starting the engine"),
                .dialogue("So much for retirement!"),
                .action("They speed off.  To destiny!"),
            ])
        }
    }
