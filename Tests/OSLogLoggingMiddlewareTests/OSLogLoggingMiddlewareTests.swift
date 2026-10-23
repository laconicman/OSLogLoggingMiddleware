import Foundation
import HTTPTypes
import OpenAPIRuntime
import Testing

@testable import OSLogLoggingMiddleware

@Suite("BodyLoggingPolicy")
struct BodyLoggingPolicyTests {
    @Test(
        arguments: [
            (.none, .never, .none),
            (.none, .upTo(maxBytes: 5), .none),
            (HTTPBody("Hello", length: .unknown), .never, .redacted),
            (HTTPBody("Hello", length: .unknown), .upTo(maxBytes: 3), .unknownLength),
            (HTTPBody("Hello", length: .unknown), .upTo(maxBytes: 5), .unknownLength),
            (HTTPBody("Hello"), .never, .redacted),
            (HTTPBody("Hello"), .upTo(maxBytes: 3), .tooManyBytesToLog(5)),
            (HTTPBody("Hello"), .upTo(maxBytes: 5), .complete(Data("Hello".utf8))),
        ] as [(HTTPBody?, BodyLoggingPolicy, BodyLoggingPolicy.BodyLog)]
    )
    func processClassifiesTheBody(
        body: HTTPBody?,
        policy: BodyLoggingPolicy,
        expected: BodyLoggingPolicy.BodyLog
    ) async throws {
        let (log, _) = try await policy.process(body)
        #expect(log == expected)
    }

    @Test("a collected body is handed on intact")
    func collectedBodyIsHandedOnIntact() async throws {
        let (_, bodyForNext) = try await BodyLoggingPolicy.upTo(maxBytes: 5).process(HTTPBody("Hello"))
        let collected = try await Data(collecting: #require(bodyForNext), upTo: 5)
        #expect(String(decoding: collected, as: UTF8.self) == "Hello")
    }
}

@Suite("OSLogLoggingMiddleware")
struct MiddlewareTests {
    @Test("intercept hands bodies through")
    func interceptHandsBodiesThrough() async throws {
        let middleware = OSLogLoggingMiddleware(bodyLoggingConfiguration: .upTo(maxBytes: 1024))
        let baseURL = try #require(URL(string: "http://example.invalid"))
        let (response, responseBody) = try await middleware.intercept(
            HTTPRequest(method: .post, scheme: nil, authority: nil, path: "/x"),
            body: HTTPBody("ping"),
            baseURL: baseURL,
            operationID: "op"
        ) { _, requestBody, _ in
            let collected = try await Data(collecting: #require(requestBody), upTo: 1024)
            #expect(String(decoding: collected, as: UTF8.self) == "ping")
            return (HTTPResponse(status: .ok), HTTPBody("pong"))
        }
        #expect(response.status == .ok)
        let collected = try await Data(collecting: #require(responseBody), upTo: 1024)
        #expect(String(decoding: collected, as: UTF8.self) == "pong")
    }
}
