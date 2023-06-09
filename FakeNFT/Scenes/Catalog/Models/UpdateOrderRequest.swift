import Foundation

struct UpdateOrderRequest: NetworkRequest {
    var httpMethod: HttpMethod = .put
    var httpBody: Data?
    var endpoint: URL?

    init(order: Order) {
        guard let endpoint = URL(string: "\(Config.baseUrl)/orders/1") else { return }
        self.endpoint = endpoint

        let encoder = JSONEncoder()
        httpBody = try! encoder.encode(order)
    }
}
