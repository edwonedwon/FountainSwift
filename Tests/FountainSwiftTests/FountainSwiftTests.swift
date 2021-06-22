    import XCTest
    @testable import FountainSwift

    final class FountainSwiftTests: XCTestCase {
        func testParsing_emptyDocument_shouldReturnNone() {
            let text = ""
            let parser = MarkdownParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [])
        }
        
        func testParsing_singleLineOfText_shouldReturnSingleTextNode() {
            let text = "Hello World"
            let parser = MarkdownParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .text("Hello World")
            ])
        }
        
        func testParsing_multipleTextBlocksWithNestedBold_shouldReturnMultipleParagraphs() {
            let text = """
            This is a text block **with some bold text**.
            
            Another paragraph with more **BOLD** text.
            """
            let parser = MarkdownParser(text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [
                .paragraph(nodes: [
                    .text("This is a text block "),
                    .bold("with some bold text"),
                    .text(".")
                ]),
                .paragraph(nodes: [
                    .text("Another paragraph wtih more "),
                    .bold("BOLD"),
                    .text(" text."),
                ])
            ])
        }
    }
