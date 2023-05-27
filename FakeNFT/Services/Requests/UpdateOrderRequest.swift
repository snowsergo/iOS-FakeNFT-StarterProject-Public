//
// Created by Сергей Махленко on 26.05.2023.
//

import Foundation

struct UpdateOrderRequest: NetworkRequest {
    private(set) var httpMethod: HttpMethod = .put
    private(set) var httpBody: Data? = nil
    var endpoint: URL?

    init(id: String, nfts_id: [String]) {
        guard let endpoint = URL(string: "\(baseUrl)/orders/\(id)") else { return }
        self.endpoint = endpoint

        let data: [String: [String]] = [ "nfts": nfts_id ]
        httpBody = try! JSONSerialization.data(withJSONObject: data)
    }
}
