//
// Created by Сергей Махленко on 02.06.2023.
//

import Foundation

class PaymentViewModel: NetworkViewModel {

    var order: Order!
    var selectedPaymentMethodId: String?

    var reloadCollectionViewClosure: (() -> Void)?
    var methodNotSelectedClosure: (() -> Void)?
    var checkedPayStatusClosure: ((_: PaymentStatus) -> Void)?

    private var cellViewModels: [Currency] = [] {
        didSet {
            reloadCollectionViewClosure?()
        }
    }

    var numberOfCells: Int {
        cellViewModels.count
    }

    // MARK: - Methods ViewModel

    func getCellViewModel(at indexPath: IndexPath) -> Currency {
        cellViewModels[indexPath.row]
    }

    func getCellIndexPath(id: String) -> IndexPath {
        IndexPath(row: cellViewModels.firstIndex(where: { $0.id == id })!, section: 0)
    }

    func fetchPaymentMethods() {
        isLoading = true
        networkClient.send(request: CurrenciesRequest(), type: [Currency].self) { [weak self] result in
            guard let self else { return }
            isLoading = false

            switch result {
            case .success(let currencies):
                self.cellViewModels = currencies
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func checkPayment() {
        guard let paymentMethodId = selectedPaymentMethodId else {
            methodNotSelectedClosure?()
            return
        }

        isLoading = true

        networkClient.send(
            request: CheckPaymentRequest(orderId: order.id, methodId: paymentMethodId),
            type: PaymentStatus.self
        ) { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success(let paymentStatus):
                self.checkedPayStatusClosure?(paymentStatus)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }

    }
}
