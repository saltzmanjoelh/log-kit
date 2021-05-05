//
//  CollectingLogger.swift
//  
//
//  Created by Joel Saltzman on 4/29/21.
//

import Foundation
import Logging

public func CollectingLogger(label: String, logCollector: LogCollector, logLevel: Logger.Level = .info) -> Logger {
    var result = Logger(label: label, factory: { _ in logCollector })
    result.logLevel = logLevel
    return result
}
