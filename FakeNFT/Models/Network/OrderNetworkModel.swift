import Foundation

//
// Created by Сергей Махленко on 26.05.2023.
//

struct OrderNetworkModel: Codable {
    let nfts: [String]
    let id: String

    static func fetchData(id: String, onResponse: @escaping (Result<OrderNetworkModel, Error>) -> Void) {
        let networkClient = DefaultNetworkClient()

        networkClient.send(request: GetOrderRequest(id: id), type: self) {
            (result: Result<OrderNetworkModel, Error>) -> Void in
                DispatchQueue.main.async {
                    onResponse(result)
                }
            }
    }

    static func updateData(
        id: String,
        nfts_id: [String],
        onResponse: @escaping (Result<Data, Error>) -> Void)
    {
        let networkClient = DefaultNetworkClient()

        networkClient.send(request: UpdateOrderRequest(id: id, nfts_id: nfts_id), type: self) {
            (result: Result<OrderNetworkModel, Error>) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
