//
// Created by Сергей Махленко on 27.05.2023.
//

import Foundation

struct CheckoutPaymentNetworkModel: Codable {
    let success: Bool
    let id: String
    let orderId: String
}
