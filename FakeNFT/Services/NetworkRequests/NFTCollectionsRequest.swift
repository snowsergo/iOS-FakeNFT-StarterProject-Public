import Foundation

struct NFTCollectionsRequest: NetworkRequest {
    var endpoint: URL?

    init() {
        guard let endpoint = URL(string: "\(Config.baseUrl)/collections") else { return }
        self.endpoint = endpoint
    }
}
