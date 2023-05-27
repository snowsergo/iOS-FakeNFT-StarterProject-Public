//
// Created by Сергей Махленко on 26.05.2023.
//

import Foundation

struct GetCurrenciesRequest: NetworkRequest {
    private(set) var httpMethod: HttpMethod = .get
    var endpoint: URL? = URL(string: "\(baseUrl)/currencies")
}
