import Foundation

public struct HTTPBody {
    var isEmpty: Bool
    var additionalHeaders: [String: String]
    var encode: () throws -> Data
}

extension HTTPBody {
    public static var empty: HTTPBody {
        HTTPBody(
            isEmpty: true,
            additionalHeaders: [:],
            encode: { Data() }
        )
    }

    public static func data(data: Data, additionalHeaders: [String: String] = [:]) -> HTTPBody {
        HTTPBody(
            isEmpty: false,
            additionalHeaders: additionalHeaders,
            encode: { data }
        )
    }

    public static func json<T: Encodable>(value: T, encoder: JSONEncoder = JSONEncoder()) -> HTTPBody  {
        HTTPBody(
            isEmpty: false,
            additionalHeaders: ["Content-Type": "application/json; charset=utf-8"],
            encode: { try encoder.encode(value) }
        )
    }

    public static func form(values: [String: String]) -> HTTPBody  {
        HTTPBody(
            isEmpty: false,
            additionalHeaders: ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"],
            encode: {
                let queryItems = values.map { URLQueryItem(name: $0.key, value: $0.value) }
                let pieces = queryItems.map { queryItem -> String in
                    let name = queryItem.name.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? ""
                    let value = queryItem.value?.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? ""
                    return "\(name)=\(value)"
                }
                let bodyString = pieces.joined(separator: "&")
                return Data(bodyString.utf8)
            }
        )
    }
}
