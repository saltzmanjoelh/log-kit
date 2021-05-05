import Logging
@testable import LogKit
import XCTest

final class LoggerTests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    /// This is for code coverage
    func testSeparator() {
        #if os(Linux)
            XCTAssertEqual(Logger.separator, " ")
        #else
            XCTAssertEqual(Logger.separator, "\n")
        #endif
    }

    func testParseTestNameWithValidInput() throws {
        // Given a valid test name
        let testClass = "TestClass"
        let testName = "testName"

        // When calling parseTestName
        let result = try Logger.parseTestName("-[\(testClass) \(testName)]")

        // Then it should return a period concatenated String
        XCTAssertEqual(result, "\(testClass).\(testName)")
    }

    func testParseTestNameWithInvalidTestName() throws {
        // Given an invalid test name
        let testName = "invalid"

        // When calling parseTestName
        do {
            _ = try Logger.parseTestName(testName)
            XCTFail("An error should have been thrown.")
        } catch LogKitError.invalidTestName(_) {
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testSetTestNameWithValidInput() {
        // Given a valid test name is used with setTestName
        let testClass = "TestClass"
        let testName = "testName"
        let collector = LogCollector()
        var logger = CollectingLogger(label: "Test", logCollector: collector)
        logger.setTestName("-[\(testClass) \(testName)]")

        // When calling log
        let value = UUID().uuidString
        logger.info("\(value)")

        // Then the test name should be in the logs
        let entry = collector.logs.filter { entry in
            entry.message.contains(value)
        }.first
        XCTAssertNotNil(entry)
        XCTAssertNotNil(entry?.metadata["test"])
        XCTAssertEqual(entry!.metadata["test"], "\(testClass).\(testName)")
    }

    func testSetTestNameWithInvalidInput() {
        // Given a valid test name is used with setTestName
        let collector = LogCollector()
        var logger = CollectingLogger(label: "Test", logCollector: collector)
        logger.setTestName("invalid")

        // When calling log
        let value = UUID().uuidString
        logger.info("\(value)")

        // Then the "InvalidTestName" should be in the logs
        let entry = collector.logs.filter { entry in
            entry.message.contains(value)
        }.first
        XCTAssertNotNil(entry)
        XCTAssertNotNil(entry?.metadata["test"])
        XCTAssertEqual(entry!.metadata["test"], "InvalidTestName")
    }

    func testURLRequestURLLogging() {
        // Given an URL
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)

        // When calling compileMessage
        let message = Logger.compileMessage(prefix: "prefix", request: request, response: nil, responseData: nil)

        // Then the URL should be logged
        XCTAssertTrue(message.description.contains(url.absoluteString))
    }

    func testURLRequestHeaderLogging() {
        // Given an some headers
        let value = UUID().uuidString
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.setValue(value, forHTTPHeaderField: "key")

        // When calling compileMessage
        let message = Logger.compileMessage(prefix: "prefix", request: request, response: nil, responseData: nil)

        // Then the header value should be logged
        XCTAssertTrue(message.description.contains("key"), "The header \"key\" should have been in the message.")
        XCTAssertTrue(message.description.contains(value), "The header value \"\(value)\" should have been in the message.")
    }

    func testURLRequestBodyLogging() {
        // Given an some URLRequest body
        let body = UUID().uuidString
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.httpBody = body.data(using: .utf8)

        // When calling compileMessage
        let message = Logger.compileMessage(prefix: "prefix", request: request, response: nil, responseData: nil)

        // Then the body should be logged
        XCTAssertTrue(message.description.contains(body), "The httpBody \"\(body)\" should have been in the message.")
    }

    func testURLResponseStatusLogging() {
        // Give an status code
        let code = 401
        let url = URL(string: "https://example.com")!
        let response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)
        let request = URLRequest(url: url)

        // When calling compileMessage
        let message = Logger.compileMessage(prefix: "prefix", request: request, response: response, responseData: nil)

        // Then the statusCode should be logged
        XCTAssertTrue(message.description.contains("\(code)"), "The statusCode \"\(code)\" should have been in the message.")
    }

    func testURLResponseHeaderLogging() {
        // Given an some headers
        let value = UUID().uuidString
        let url = URL(string: "https://example.com")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["key": value])
        let request = URLRequest(url: url)

        // When calling compileMessage
        let message = Logger.compileMessage(prefix: "prefix", request: request, response: response, responseData: nil)

        // Then the header value should be logged
        XCTAssertTrue(message.description.contains(value), "The header value \"\(value)\" should have been in the message.")
    }

    func testURLResponseDataLogging() {
        // Given some response dataa
        let data = UUID().uuidString
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)

        // When calling compileMessage
        let message = Logger.compileMessage(prefix: "prefix", request: request, response: nil, responseData: data.data(using: .utf8))

        // Then the statusCode should be logged
        XCTAssertTrue(message.description.contains(data), "The response data \"\(data)\" should have been in the message.")
    }

    static var allTests = [
        ("testSeparator", testSeparator),
        ("testParseTestNameWithValidInput", testParseTestNameWithValidInput),
        ("testParseTestNameWithInvalidTestName", testParseTestNameWithInvalidTestName),
        ("testSetTestNameWithValidInput", testSetTestNameWithValidInput),
        ("testSetTestNameWithInvalidInput", testSetTestNameWithInvalidInput),
        ("testURLRequestURLLogging", testURLRequestURLLogging),
        ("testURLRequestHeaderLogging", testURLRequestHeaderLogging),
        ("testURLRequestBodyLogging", testURLRequestBodyLogging),
        ("testURLResponseStatusLogging", testURLResponseStatusLogging),
        ("testURLResponseHeaderLogging", testURLResponseHeaderLogging),
    ]
}
