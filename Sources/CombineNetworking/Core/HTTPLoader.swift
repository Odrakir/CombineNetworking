import Foundation
import Combine

open class HTTPLoader {

    public var decoder: JSONDecoder = JSONDecoder()

    public var nextLoader: HTTPLoader? {
        willSet {
            guard nextLoader == nil else { fatalError("The nextLoader may only be set once") }
        }
    }

    public init() { }

    open func load(request: HTTPRequest) -> AnyPublisher<HTTPResponse, HTTPError> {
        if let next = nextLoader {
            return next.load(request: request)
        } else {
            let error = HTTPError(code: .cannotConnect, request: request)
            return Fail<HTTPResponse, HTTPError>(error: error)
                .eraseToAnyPublisher()
        }
    }
}

//extension HTTPLoader {
//    public func load<T: Decodable>(request: HTTPRequest) -> AnyPublisher<T, Error> {
//        load(request: request)
//            .tryMap { response in
//                guard let data = response.body else { fatalError() }
//                return try self.decoder.decode(T.self, from: data)
//            }
//            .eraseToAnyPublisher()
//    }
//}
