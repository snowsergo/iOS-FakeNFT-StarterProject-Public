//
// Created by Сергей Махленко on 27.05.2023.
//

import Foundation

struct GetCheckoutPaymentRequest: NetworkRequest {
    var endpoint: URL?

    init(orderId: String, currencyId: String) {
        guard let endpoint = URL(string: "\(Config.baseUrl)/api/v1/orders/\(orderId)/payment/\(currencyId)") else { return }
        self.endpoint = endpoint
    }
}
