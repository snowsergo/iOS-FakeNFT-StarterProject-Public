//
// Created by Сергей Махленко on 02.06.2023.
//

import Foundation

final class ConfirmationDeleteViewModel: NetworkViewModel {

    var successfulClosure: (() -> Void)?

    // MARK: - Methods ViewModel

    func removeItemFromOrder(order: Order, item: Nft) {
        let newListNfts = order.nfts.filter({ $0 != item.id })
        let newOrder = Order(nfts: newListNfts, id: order.id)

        isLoading = true

        networkClient.send(request: UpdateOrderRequest(order: newOrder), type: Order.self) { (result: Result<Order, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                self.isLoading = false

                switch result {
                case .success(let order):
                    if newOrder.nfts.count == order.nfts.count && Set(newOrder.nfts).isSubset(of: Set(order.nfts)) {
                        self.successfulClosure?()
                    } else {
                        self.errorMessage = "Ошибка удаления NFT."
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
