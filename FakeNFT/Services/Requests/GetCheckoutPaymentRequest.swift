//
// Created by Сергей Махленко on 27.05.2023.
//

import Foundation

struct GetCheckoutPaymentRequest: NetworkRequest {
    var httpMethod: HttpMethod = .get
    var endpoint: URL?

    init(orderId: String, currencyId: String) {
        guard let endpoint = URL(string: "\(baseUrl)/orders/\(orderId)/payment/\(currencyId)") else { return }
        self.endpoint = endpoint
    }
}
