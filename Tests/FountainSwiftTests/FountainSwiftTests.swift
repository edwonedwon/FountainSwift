    import XCTest
    @testable import FountainSwift

    final class FountainSwiftTests: XCTestCase {
        func testParsing_thing() {
            let text = """
            EXT. BRICK'S PATIO - DAY

            A gorgeous day.  The sun is shining.  But BRICK BRADDOCK, retired police detective, is sitting quietly, contemplating -- something.

            The SCREEN DOOR slides open and DICK STEEL, his former partner and fellow retiree, emerges with two cold beers.

            STEEL
            Beer's ready!
            """
            let parser = FountainParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .sceneHeading("EXT. BRICK'S PATIO - DAY"),
                .action("A gorgeous day.  The sun is shining.  But BRICK BRADDOCK, retired police detective, is sitting quietly, contemplating -- something."),
                .action("The SCREEN DOOR slides open and DICK STEEL, his former partner and fellow retiree, emerges with two cold beers."),
                .dialogue(Dialogue(character: "STEEL", dialogue: "Beer's ready!"))
            ])
        }
    }
