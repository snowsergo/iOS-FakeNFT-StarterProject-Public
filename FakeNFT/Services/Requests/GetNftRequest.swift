//
// Created by Сергей Махленко on 26.05.2023.
//

import Foundation

struct GetNftRequest: NetworkRequest {
    private(set) var httpMethod: HttpMethod = .get
    var endpoint: URL?

    init(id: String) {
        guard let endpoint = URL(string: "https://64611c69491f9402f49ecce1.mockapi.io/api/v1/nft/\(id)") else { return }
        self.endpoint = endpoint
    }
}
