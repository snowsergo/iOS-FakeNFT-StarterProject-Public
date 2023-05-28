import Foundation

final class StatisticsUserCollectionPageViewModel {
    var onChange: (() -> Void)?

    private(set) var nfts: [Nft]=[] {
        didSet {
            onChange?()
        }
    }

    let defaultNetworkClient = DefaultNetworkClient()

    func getUserNfts(ids: [Int]) {
        for id in ids {
            let request = Request(endpoint: URL(string: defaultBaseUrl + "/nft" + "/\(id)"), httpMethod: .get)
            let fulfillCompletionOnMainThread: (Result<Nft, Error>) -> Void = { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let nft):
                        self.nfts.append(nft)
                    case .failure:
                        print("___failure")
                    }
                }
            }
            defaultNetworkClient.send(request: request, type: Nft.self, onResponse: fulfillCompletionOnMainThread)
        }

    }
}
