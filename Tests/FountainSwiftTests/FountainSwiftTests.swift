    import XCTest
    @testable import FountainSwift

    final class FountainSwiftTests: XCTestCase {
        func testParsing_emptyDocument_shouldReturnNone() {
            let text = ""
            let parser = MarkdownParser(text: text)
            let nodes = parser.parse()
            XCTAssertEqual(nodes, [])
        }
    }
