import Foundation
import Combine

public struct HTTPResponse {
    public let request: HTTPRequest
    public let body: Data?

    private let response: HTTPURLResponse

    public var status: HTTPStatus {
        HTTPStatus(rawValue: response.statusCode)
    }

    public var message: String {
        HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }

    public var headers: [AnyHashable: Any] { response.allHeaderFields }

    public init(request: HTTPRequest, response: HTTPURLResponse, body: Data?) {
        self.request = request
        self.response = response
        self.body = body
    }
}

extension Publisher where Output == HTTPResponse, Failure == HTTPError {
    public func decode<T: Decodable>(with decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        self.tryMap { response in
            guard let data = response.body else { fatalError() }
            return try decoder.decode(T.self, from: data)
        }
        .eraseToAnyPublisher()
    }
}
