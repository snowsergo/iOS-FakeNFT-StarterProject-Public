//
// Created by Сергей Махленко on 27.05.2023.
//

struct PaymentStatus: Codable {
    let success: Bool
    let id: String
    let orderId: String
}
