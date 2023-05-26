//
// Created by Сергей Махленко on 26.05.2023.
//

import Foundation

struct NftNetworkModel: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let id: String

    static func fetchData(id: String, onResponse: @escaping (Result<NftNetworkModel, Error>) -> Void) {
        let networkClient = DefaultNetworkClient()

        networkClient.send(request: GetNftRequest(id: id), type: self) {
            (result: Result<NftNetworkModel, Error>) -> Void in
            DispatchQueue.main.async {
                onResponse(result)
            }
        }
    }
}
