//
// Created by Сергей Махленко on 27.05.2023.
//

import Foundation

struct CheckPaymentRequest: NetworkRequest {
    var endpoint: URL?

    init(orderId: String, methodId: String) {
        guard let endpoint = URL(string: "\(Config.baseUrl)/api/v1/orders/\(orderId)/payment/\(methodId)") else { return }
        self.endpoint = endpoint
    }
}
