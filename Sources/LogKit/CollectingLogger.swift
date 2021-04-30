//
//  CollectingLogger.swift
//  
//
//  Created by Joel Saltzman on 4/29/21.
//

import Foundation
import Logging

extension Logger {
    
    public static var sharedCollector = LogCollector(.init(), logLevel: .trace)
    
    /// The default implement of this uses a `sharedCollector` and all logs are collected in one place. This is typically used with testing.
    /// If you don't want this behavior, use `CollectingLogger(label:logLevel:logCollector:)` and keep a
    /// reference to your `LogCollector` instance
    public static func CollectingLogger(label: String) -> Logger {
        return Logger(label: label, factory: { _ in sharedCollector })
    }
    
    public static func CollectingLogger(label: String, logCollector: LogCollector) -> Logger {
        return Logger(label: label, factory: { _ in logCollector })
    }
}
