import XCTest

import LoggerTests

var tests = [XCTestCaseEntry]()
tests += LoggerTests.allTests()
tests += LogCollectorTests.allTests()
XCTMain(tests)
