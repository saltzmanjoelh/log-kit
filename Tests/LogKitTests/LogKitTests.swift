import XCTest
import Logging
@testable import LogKit

final class LogKitTests: XCTestCase {
    
//    override class func setUp() {
//        LoggingSystem.bootstrap { label in
//            var handler = XCTestLogHandler(streamLogger: StreamLogHandler.standardOutput(label: label))
//            handler.logLevel = .debug
//            return handler
//        }
//    }
    override func setUp() {
        Logger.default.setTestName(self.name)
    }
    
    func testExample() {
        Logger.default.logLevel = .debug
        Logger.default.debug("!!! Logging debug details")
        Logger.default.info("!!! Logging info details")
        Logger.default.error("!!! Logging error details")
    }
    
    /*func testLogHandler() {
        
        var logger1 = Logger(label: "first logger")
        logger1.logLevel = .debug
        logger1[metadataKey: "only-on"] = "first"
        
        var logger2 = logger1
        logger2.logLevel = .error                  // this must not override `logger1`'s log level
        logger2[metadataKey: "only-on"] = "second" // this must not override `logger1`'s metadata
        
        XCTAssertEqual(.debug, logger1.logLevel)
        XCTAssertEqual(.error, logger2.logLevel)
        XCTAssertEqual("first", logger1[metadataKey: "only-on"])
        XCTAssertEqual("second", logger2[metadataKey: "only-on"])
    }*/

    static var allTests = [
        ("testExample", testExample),
//        ("testLogHandler", testLogHandler),
    ]
}
