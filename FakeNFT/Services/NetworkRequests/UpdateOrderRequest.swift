//
// Created by Сергей Махленко on 26.05.2023.
//

import Foundation

struct UpdateOrderRequest: NetworkRequest {
    var httpMethod: HttpMethod = .put
    var httpBody: Data? = nil
    var endpoint: URL?

    init(order: Order) {
        guard let endpoint = URL(string: "\(Config.baseUrl)/api/v1/orders/\(order.id)") else { return }
        self.endpoint = endpoint

        let encoder = JSONEncoder()
        httpBody = try! encoder.encode(order)
    }
}
