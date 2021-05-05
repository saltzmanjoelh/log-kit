import Foundation
import Logging
#if os(Linux)
    import FoundationNetworking
#endif

public extension Logger {
    static var separator: String {
        #if os(Linux)
            return " "
        #else
            return "\n"
        #endif
    }

    /// Compile a more detailed message about an URLRequest and it's response. The default separator for Linux is a space
    /// so that the logs in CloudWatch will be grouped on the same line. Otherwise, the default is a newline.
    static func compileMessage(prefix _: String,
                               request: URLRequest,
                               response: URLResponse?,
                               responseData: Data?,
                               separator: String = Self.separator) -> Logger.Message
    {
        var components = [String]()
        if let url = request.url {
            components.append("Request URL: \(url.absoluteString)")
        }
        if let headers = request.allHTTPHeaderFields,
           headers.count > 0
        {
            components.append("Request Headers: \(headers)")
        }
        if let requestData = request.httpBody,
           let requestBody = String(data: requestData, encoding: .utf8)
        {
            components.append("Request Body: \(requestBody)")
        }
        if let httpResponse = response as? HTTPURLResponse {
            components.append("Response Status: \(httpResponse.statusCode)")
            if httpResponse.allHeaderFields.count > 0 {
                components.append("Response Headers: \(httpResponse)")
            }
        }
        if let data = responseData,
           let responseBody = String(data: data, encoding: .utf8)
        {
            components.append("Response Body: \(responseBody)")
        }

        return "\(components.joined(separator: "\n").replacingOccurrences(of: "\n", with: separator))"
    }
}

// MARK: - Testing

public enum LogKitError: Error, CustomStringConvertible {
    case invalidTestName(String)
    public var description: String {
        switch self {
        case let .invalidTestName(name):
            return "Invalid test name: \(name). It should be in the format: \"-[TestClass testName]\"."
        }
    }
}

extension Logger {
    /// In the setup function of your tests, use this to add the test name to the logs.
    /// It will change the logs of `Logger.default.debug("!!! Logging debug details")`
    /// from looking like this:
    /// `2021-02-28T08:27:53-0800 debug com.apple.dt.xctest.tool : !!! Logging debug details`
    /// into this:
    /// `2021-02-28T08:29:05-0800 debug com.apple.dt.xctest.tool : test=LogKitTests.testExample !!! Logging debug details`
    ///
    /// ```swift
    /// override func setUp() {
    ///     Logger.default.setTestName(self.name)
    /// }
    /// ```
    public mutating func setTestName(_ testName: String) { // -[TestClass testName]
        // We don't throw in here because we don't want the user to be required to call `setUpWithError`
        do {
            self[metadataKey: "test"] = Logger.MetadataValue.string(try Self.parseTestName(testName))
        } catch {
            self[metadataKey: "test"] = "InvalidTestName"
        }
    }

    // -[TestClass testName]
    static func parseTestName(_ testName: String) throws -> String {
        let parts = testName.replacingOccurrences(of: "-[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .components(separatedBy: " ")
        guard let testClass = parts.first,
              let testFunction = parts.last,
              testClass != testFunction
        else { throw LogKitError.invalidTestName(testName) }
        return "\(testClass).\(testFunction)"
    }
}
