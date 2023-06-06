//
// Created by Сергей Махленко on 02.06.2023.
//

import Foundation

final class CartViewModel: NetworkViewModel {
    var order: Order?

    var reloadTableViewClosure: (() -> Void)?

    var removeTableCellClosure: ((_ indexPath: IndexPath) -> Void)?

    private var cellViewModels: [Nft] = []

    var numberOfCells: Int {
        cellViewModels.count
    }

    var totalPriceCells: String {
        String(format: "%.02f", cellViewModels.reduce(0) { $0 + $1.price })
    }

    // MARK: - Methods ViewModel

    func getCellViewModel(at indexPath: IndexPath) -> Nft {
        cellViewModels[indexPath.row]
    }

    func getCellIndexPath(id: String) -> IndexPath {
        let row = cellViewModels.firstIndex { nft in
            nft.id == id
        }

        return IndexPath(row: row!, section: 0)
    }

    func sort(by: CartSortType) {
        cellViewModels.sort { (lhs: Nft, rhs: Nft) -> Bool in
            switch by {
            case .name: return lhs.name < rhs.name
            case .price: return lhs.price < rhs.price
            case .rating: return lhs.rating < rhs.rating
            }
        }

        reloadTableViewClosure?()
    }

    func removeCellViewModel(at indexPath: IndexPath) {
        removeTableCellClosure?(indexPath)
        cellViewModels.remove(at: indexPath.row)
    }

    func fetchOrder(id: String) {
        isLoading = true
        order = nil

        networkClient.send(request: OrderRequest(id: id), type: Order.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let order):
                self.order = order

                if order.nfts.count > 0 {
                    let dispatchGroup = DispatchGroup()

                    var cells: [Nft] = []
                    order.nfts.forEach { id in
                        dispatchGroup.enter()
                        DispatchQueue.main.async { [weak self] in
                            self?.fetchNft(id: id) { nft in
                                cells.append(nft)
                                dispatchGroup.leave()
                            }
                        }
                    }

                    dispatchGroup.notify(queue: .main) {
                        cells.sort { nft, nft2 in
                            nft.id < nft2.id
                        }

                        self.cellViewModels = cells
                        self.isLoading = false
                        self.reloadTableViewClosure?()
                    }
                } else {
                    self.cellViewModels = []
                    self.isLoading = false
                    self.reloadTableViewClosure?()
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    private func fetchNft(id: Int, onResponse: @escaping (_ nft: Nft) -> Void ) {
        networkClient.send(request: NftRequest(id: id), type: Nft.self) { [weak self] result in
            switch result {
            case .success(let nft):
                onResponse(nft)
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
            }
        }
    }
}
