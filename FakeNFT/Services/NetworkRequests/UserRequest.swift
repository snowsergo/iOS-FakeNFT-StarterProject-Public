import Foundation

struct UserRequest: NetworkRequest {
    var endpoint: URL?

    init(id: Int) {
        guard let endpoint = URL(string: "\(Config.baseUrl)/users/\(id)") else { return }
        self.endpoint = endpoint
    }
}
