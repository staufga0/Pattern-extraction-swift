import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(pattern_extraction_swiftTests.allTests),
    ]
}
#endif
