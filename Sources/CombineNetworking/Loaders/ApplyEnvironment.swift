import Foundation
import Combine

public class ApplyEnvironment: HTTPLoader {

    private let environment: ServerEnvironment

    public init(environment: ServerEnvironment) {
        self.environment = environment
        super.init()
    }

    override public func load(request: HTTPRequest) -> AnyPublisher<HTTPResponse, HTTPError> {
        var copy = request

        if copy.host == nil {
            copy.host = environment.host
        }

        if let pathPrefix = environment.pathPrefix { //}, !copy.path.hasPrefix("/") {
            copy.path = "\(pathPrefix)" + copy.path
        }

        for (header, value) in environment.headers {
            if copy.headers[header] == nil {
                copy.headers[header] = value
            }
        }

        return super.load(request: copy)
    }
}

public struct ServerEnvironment {
    public var host: String
    public var pathPrefix: String?
    public var headers: [String: String]
    public var query: [URLQueryItem]

    public init(host: String, pathPrefix: String? = nil, headers: [String: String] = [:], query: [URLQueryItem] = []) {
        self.host = host
        self.headers = headers
        self.query = query
        self.pathPrefix = pathPrefix
    }
}
