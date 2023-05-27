//
// Created by Сергей Махленко on 26.05.2023.
//

import Foundation

struct UpdateOrderRequest: NetworkRequest {
    var httpMethod: HttpMethod = .put
    var httpBody: Data? = nil
    var endpoint: URL?

    init(orderId: String, nftsId: [String]) {
        guard let endpoint = URL(string: "\(Config.baseUrl)/api/v1/orders/\(orderId)") else { return }
        self.endpoint = endpoint

        let data: [String: [String]] = [ "nfts": nftsId ]
        httpBody = try! JSONSerialization.data(withJSONObject: data)
    }
}
