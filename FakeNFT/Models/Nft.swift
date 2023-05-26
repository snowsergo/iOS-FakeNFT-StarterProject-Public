import Foundation

struct Nft {
    let createdAt: Date
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let id: String

    static func make(by: NftNetworkModel) -> Nft {
        let dateFormatter = DateFormatter.defaultDateFormatter

        return Nft(
            createdAt: dateFormatter.date(from: by.createdAt)!,
            name: by.name,
            images: by.images,
            rating: by.rating,
            description: by.description,
            price: by.price,
            id: by.id)
    }
}
