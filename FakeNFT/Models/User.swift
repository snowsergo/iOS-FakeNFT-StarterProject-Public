import Foundation

struct User: Codable {
    let avatar: String
    let name: String
    let description: String
    let website: String
    let nfts: [Int]
    let rating: String
    let id: String
}
