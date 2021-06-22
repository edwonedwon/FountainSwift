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
                .text("EXT. BRICK'S PATIO - DAY"),
                .text("A gorgeous day.  The sun is shining.  But BRICK BRADDOCK, retired police detective, is sitting quietly, contemplating -- something."),
                .text("The SCREEN DOOR slides open and DICK STEEL, his former partner and fellow retiree, emerges with two cold beers."),
                .text("STEEL\nBeer's ready!"),
            ])
        }
        
//        func testParsing_emptyDocument_shouldReturnNone() {
//            let text = ""
//            let parser = MarkdownParser(text)
//            let nodes = parser.parse()
//            XCTAssertEqual(nodes, [])
//        }
        
//        func testParsing_singleLineOfText_shouldReturnSingleTextNode() {
//            let text = "Hello World"
//            let parser = MarkdownParser(text)
//            let nodes = parser.parse()
//            XCTAssertEqual(nodes, [
//                .text("Hello World")
//            ])
//        }
//
//        func testParsing_multipleTextBlocksWithNestedBold_shouldReturnMultipleParagraphs() {
//            let text = """
//            This is a text block **with some bold text**.
//
//            Another paragraph with more **BOLD** text.
//            """
//            let parser = MarkdownParser(text)
//            let nodes = parser.parse()
//            XCTAssertEqual(nodes, [
//                .paragraph(nodes: [
//                    .text("This is a text block "),
//                    .bold("with some bold text"),
//                    .text(".")
//                ]),
//                .paragraph(nodes: [
//                    .text("Another paragraph wtih more "),
//                    .bold("BOLD"),
//                    .text(" text."),
//                ])
//            ])
//        }
    }
