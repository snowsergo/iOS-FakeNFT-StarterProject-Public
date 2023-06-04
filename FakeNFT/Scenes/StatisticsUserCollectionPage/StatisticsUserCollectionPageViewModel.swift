import Foundation

final class StatisticsUserCollectionPageViewModel {

    private let model: StatisticsUserCollectionModel

    var onChange: (() -> Void)?

    private(set) var nfts: [Nft]=[] {
        didSet {
            onChange?()
        }
    }

    init(model: StatisticsUserCollectionModel) {
        self.model = model
    }

    func getUserNfts(ids: [Int], showLoader: @escaping (_ active: Bool) -> Void ) {
        showLoader(true)
                model.fetchNfts(ids: ids) { [weak self] result in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let nfts):
                            self.nfts = nfts
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                        showLoader(false)
                    }
                }
    }
}
