//
// Created by Сергей Махленко on 26.05.2023.
//

import UIKit
import Kingfisher

struct Nft: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let id: String

    func previewUrl() -> URL? {
        guard let previewUrl = images.first else { return nil }
        return URL(string: previewUrl)
    }
}
