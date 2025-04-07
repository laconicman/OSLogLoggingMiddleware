import XCTest
@testable import OSLogLoggingMiddleware

import OpenAPIRuntime
import XCTest

@testable import OSLogLoggingMiddleware

final class OSLogLoggingMiddlewareTests: XCTestCase {

    func testBodyLoggingPolicy() async throws {
        for (body, bodyLoggingPolicy, expectedMessage): (HTTPBody?, BodyLoggingPolicy, BodyLoggingPolicy.BodyLog) in [
            (.none, .never, .none), (.none, .upTo(maxBytes: 5), .none),
            (HTTPBody("Hello", length: .unknown), .never, .redacted),
            (HTTPBody("Hello", length: .unknown), .upTo(maxBytes: 3), .unknownLength),
            (HTTPBody("Hello", length: .unknown), .upTo(maxBytes: 5), .unknownLength),
            (HTTPBody("Hello"), .never, .redacted), (HTTPBody("Hello"), .upTo(maxBytes: 3), .tooManyBytesToLog(5)),
            (HTTPBody("Hello"), .upTo(maxBytes: 5), .complete(Data("Hello".utf8))),
        ] {
            let (bodyToLog, _) = try await bodyLoggingPolicy.process(body)
            XCTAssertEqual(bodyToLog, expectedMessage)
        }
    }
}
