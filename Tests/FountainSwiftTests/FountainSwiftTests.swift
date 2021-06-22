    import XCTest
    @testable import FountainSwift

    final class FountainSwiftTests: XCTestCase {
        func testExample() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct
            // results.
            XCTAssertEqual(FountainSwift().text, "Hello, World!")
        }
        
        func testParsing_emptyDocument_shouldReturnNone() {
            let text = ""
            let parser = MarkdownParser(text: text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [])
        }
    }
