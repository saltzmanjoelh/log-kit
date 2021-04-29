//
//  PrintLogHandler.swift
//  
//
//  Created by Joel Saltzman on 2/27/21.
//

import Foundation
import Logging

/*
public struct XCTestLogHandler: LogHandler {
    
    public var streamLogger = StreamLogHandler.standardOutput(label: "XTestCase")
    
    public init(streamLogger: StreamLogHandler) {
        self.streamLogger = streamLogger
    }

    public var metadata: Logger.Metadata {
        get {
            return streamLogger.metadata
        }
        set {
            self.streamLogger.metadata = newValue
        }
    }
    
    public var logLevel: Logger.Level {
        get {
            return self.streamLogger.logLevel
        }
        set {
            self.streamLogger.logLevel = newValue
        }
    }
    
    public subscript(metadataKey metadataKey: Logger.Metadata.Key) -> Logger.Metadata.Value? {
        get {
            return self.streamLogger.metadata[metadataKey]
        }
        set {
            self.streamLogger.metadata[metadataKey] = newValue
        }
    }
    public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?,
                    source: String, file: String, function: String, line: UInt) {
        streamLogger.log(level: level, message: message, metadata: metadata, source: source, file: file, function: function, line: line)
    }
}
*/
