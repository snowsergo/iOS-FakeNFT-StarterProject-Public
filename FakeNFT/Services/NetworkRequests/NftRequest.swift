//
// Created by Сергей Махленко on 26.05.2023.
//

import Foundation

struct NftRequest: NetworkRequest {
    var endpoint: URL?

    init(id: Int) {
        guard let endpoint = URL(string: "\(Config.baseUrl)/nft/\(id)") else { return }
        self.endpoint = endpoint
    }
}
