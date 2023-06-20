import Foundation

struct AllNFTsRequest: NetworkRequest {
    var endpoint: URL?

    init() {
        guard let endpoint = URL(string: "\(Config.baseUrl)/nft") else { return }
        self.endpoint = endpoint
    }
}
