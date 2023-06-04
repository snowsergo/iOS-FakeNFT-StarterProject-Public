//
// Created by Сергей Махленко on 02.06.2023.
//

import Foundation

final class ConfirmationDeleteViewModel: NetworkViewModel {

    var order: Order!

    var successfulClosure: ((_: Order) -> Void)?

    // MARK: - Methods ViewModel

    func orderWithoutNft(item: Nft) -> Order {
        let newListNfts = order.nfts.filter({ $0 != Int(item.id) })
        return Order(nfts: newListNfts, id: order.id)
    }

    func removeItemFromOrder(item: Nft) {
        order = orderWithoutNft(item: item)

        isLoading = true

        networkClient.send(request: UpdateOrderRequest(order: order), type: Order.self) { (result: Result<Order, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                self.isLoading = false

                switch result {
                case .success(let order):
                    if self.order.nfts.count == order.nfts.count {
                        self.successfulClosure?(self.order)
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
