import Foundation

public struct HTTPRequest {
    private var urlComponents = URLComponents()
    public let id: UUID
    public var method: HTTPMethod = .get
    public var headers: [String: String] = [:]
    public var body: HTTPBody = .empty

    public init() {
        id = UUID()
        urlComponents.scheme = "https"        
    }

    public init(
        method: HTTPMethod = .get,
        path: String,
        queryItems: [String: String] = [:],
        headers: [String: String] = [:]
    ) {
        self.init()
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
    }
}

public extension HTTPRequest {

    var scheme: String { urlComponents.scheme ?? "https" }

    var host: String? {
        get { urlComponents.host }
        set { urlComponents.host = newValue }
    }

    var path: String {
        get { urlComponents.path }
        set { urlComponents.path = newValue }
    }

    var url: URL? {
        urlComponents.url
    }

    var queryItems: [String: String]? {
        get {
            urlComponents.queryItems?.reduce([String: String](), { acc, item in
                var copy = acc
                copy[item.name] = item.value
                return copy
            })
        }
        set {
            guard let newValue = newValue else {
                urlComponents.queryItems = nil
                return
            }
            urlComponents.queryItems = newValue.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
    }

    func toURLRequest() throws -> URLRequest {
        guard let url = url else {
            throw HTTPError(code: .invalidRequest, request: self)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        for (header, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: header)
        }

        if body.isEmpty == false {
            for (header, value) in body.additionalHeaders {
                urlRequest.addValue(value, forHTTPHeaderField: header)
            }

            do {
                urlRequest.httpBody = try body.encode()
            } catch {
                throw HTTPError(code: .invalidRequest, request: self)
            }
        }

        return urlRequest
    }
}
