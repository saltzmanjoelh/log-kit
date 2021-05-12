//
//  LogCollectorTests.swift
//
//
//  Created by Joel Saltzman on 4/29/21.
//

import Foundation
import Logging
@testable import LogKit
import XCTest

class LogCollectorTests: XCTestCase {
    func testLog() {
        // Given a String
        let message = "!!! Logging debug details"
        let handler = LogCollector()

        // When log is called
        handler.log(level: .debug, message: "\(message)")

        // Then an entry should be stored
        let entry = handler.logs.allEntries.first
        XCTAssertNotNil(handler.logs.filter(message: message).first)
        XCTAssertNotNil(entry?.message)
    }

    func testLogWithAdditionalMetadata() {
        // Given a handler with metadata
        var handler = LogCollector()
        handler[metadataKey: "initial"] = "initial"

        // When log is called with additional metadata
        handler.log(level: .debug, message: "message", metadata: ["updated": "updated"])

        // Then an entry should be stored with both metadata entries
        let entry = handler.logs.allEntries.last
        XCTAssertNotNil(entry?.metadata)
        XCTAssertEqual(entry?.metadata.count, 2)
    }

    func testMetadata() {
        // Given a metadata value
        let value = UUID().uuidString
        var handler = LogCollector()
        handler[metadataKey: "key"] = "\(value)"

        // When the metadata is set
        handler.log(level: .debug, message: "message")

        // Then a log should be stored with the metadata value
        let entry = handler.logs.allEntries.first
        XCTAssertNotNil(handler.logs.filter(metadata: "key").first)
        XCTAssertNotNil(handler.logs.filter(metadata: "key", with: value).first)
        XCTAssertNotNil(handler[metadataKey: "key"])
        XCTAssertNotNil(entry?.metadata["key"])
        XCTAssertEqual(entry!.metadata["key"], value)
    }

    func testCollectingLoggerHelper() {
        // Given a logger from Logger.CollectingLogger
        let handler = LogCollector()
        var logger = CollectingLogger(label: "test", logCollector: handler)
        logger.logLevel = .trace
        let message =  UUID().uuidString

        // When a log is made
        logger.debug("\(message)")

        // Then an entry should be created
        XCTAssertNotNil(handler.logs.allEntries.first)
        XCTAssertTrue(handler.logs.allMessages.contains(message), "Log messages should have contained the value: \"\(message)\"")
    }

    static var allTests = [
        ("testLog", testLog),
        ("testLogWithAdditionalMetadata", testLogWithAdditionalMetadata),
        ("testMetadata", testMetadata),
    ]
}
