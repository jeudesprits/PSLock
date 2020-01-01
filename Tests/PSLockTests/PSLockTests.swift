import XCTest
@testable import PSLock

final class PSLockTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PSLock().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
