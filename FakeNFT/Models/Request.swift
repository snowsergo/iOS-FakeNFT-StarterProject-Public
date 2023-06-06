import Foundation

struct Request: NetworkRequest {
    var endpoint: URL?
    var queryParameters: [String: String]?
    var httpMethod: HttpMethod
}
