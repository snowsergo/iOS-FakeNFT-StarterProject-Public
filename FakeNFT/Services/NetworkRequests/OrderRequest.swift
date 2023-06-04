//
// Created by Сергей Махленко on 26.05.2023.
//

import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL?

    init(id: String) {
        guard let endpoint = URL(string: "\(Config.baseUrl)/api/v1/orders/\(id)") else { return }
        self.endpoint = endpoint
    }
}
