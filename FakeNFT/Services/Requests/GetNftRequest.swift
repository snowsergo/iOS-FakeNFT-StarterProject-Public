//
// Created by Сергей Махленко on 26.05.2023.
//

import Foundation

struct GetNftRequest: NetworkRequest {
    var endpoint: URL?

    init(id: String) {
        guard let endpoint = URL(string: "\(Config.baseUrl)/api/v1/nft/\(id)") else { return }
        self.endpoint = endpoint
    }
}
