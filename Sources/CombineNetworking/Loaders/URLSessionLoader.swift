import Foundation
import Combine

public class URLSessionLoader: HTTPLoader {
    let session: URLSession

    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    public override func load(request: HTTPRequest) -> AnyPublisher<HTTPResponse, HTTPError> {

        let urlRequest: URLRequest

        do {
            urlRequest = try request.toURLRequest()
        } catch let error as HTTPError {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: HTTPError(code: .unknown, request: request))
                .eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                if let response = response as? HTTPURLResponse {
                    return HTTPResponse(request: request, response: response, body: data)
                } else {
                    throw HTTPError(code: .invalidResponse, request: request)
                }
            }
            .mapError { error in
                guard let networkingError = error as? HTTPError else {
                    return HTTPError(code: .unknown, request: request, underlyingError: error)
                }

                return networkingError
            }
            .eraseToAnyPublisher()
    }
}

extension URLSession {
    public static var loader: URLSessionLoader {
        URLSessionLoader(session: URLSession.shared)
    }
}
