//
// Created by Сергей Махленко on 26.05.2023.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? = URL(string: "\(Config.baseUrl)/api/v1/currencies")
}
