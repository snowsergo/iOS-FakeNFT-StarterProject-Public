//
// Created by Сергей Махленко on 26.05.2023.
//

struct Nft: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let id: String
}
