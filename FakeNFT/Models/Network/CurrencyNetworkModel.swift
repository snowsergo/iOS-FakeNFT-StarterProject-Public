import Foundation

//
// Created by Сергей Махленко on 26.05.2023.
//

struct CurrencyNetworkModel: Codable {
    let title: String
    let name: String
    let image: String
    let id: String

    static func fetchData(onResponse: @escaping (Result<[CurrencyNetworkModel], Error>) -> Void) {
        let networkClient = DefaultNetworkClient()

        networkClient.send(request: GetCurrenciesRequest(), type: [CurrencyNetworkModel].self) {
            (result: Result<[CurrencyNetworkModel], Error>) -> Void in
                DispatchQueue.main.async {
                    onResponse(result)
                }
            }
    }
}
