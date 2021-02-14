import Foundation
import Combine

public class Authenticate: HTTPLoader {

    private var credentials: BasicCredentials?

    public convenience init(username: String, password: String) {
        self.init(credentials: BasicCredentials(
                    username: username,
                    password: password
        ))
    }

    public init(credentials: BasicCredentials?) {
        self.credentials = credentials
        super.init()
    }

    override public func load(request: HTTPRequest) -> AnyPublisher<HTTPResponse, HTTPError> {
        var copy = request

        if let credentials = credentials {
            let joined = credentials.username + ":" + credentials.password
            let data = Data(joined.utf8)
            let encoded = data.base64EncodedString()
            let header = "Basic \(encoded)"
            copy.headers["Authorization"] = header
        }

        return super.load(request: copy)
    }
}

public struct BasicCredentials: Hashable, Codable {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
