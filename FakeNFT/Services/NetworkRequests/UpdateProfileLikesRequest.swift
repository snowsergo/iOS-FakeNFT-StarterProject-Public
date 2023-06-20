import Foundation

struct UpdateProfileLikesRequest: NetworkRequest {
    var httpMethod: HttpMethod = .put
    var httpBody: Data?
    var endpoint: URL?

    init(id: Int, likes: NFTLiked) {
        guard let endpoint = URL(string: "\(Config.baseUrl)/profile/\(id)") else { return }
        self.endpoint = endpoint

        let encoder = JSONEncoder()
        httpBody = try! encoder.encode(likes)
    }
}
