import Foundation

struct NFTCollectionRequest: NetworkRequest {
    var endpoint: URL?

    init(id: Int) {
        guard let endpoint = URL(string: "\(Config.baseUrl)/collections/\(id)") else { return }
        self.endpoint = endpoint
    }
}
