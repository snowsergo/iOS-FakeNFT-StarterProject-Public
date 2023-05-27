//
// Created by Сергей Махленко on 18.05.2023.
//

import UIKit
import ProgressHUD

enum CartNftSortable: String, CaseIterable {
    case price = "По цене"
    case name = "По названию"
    case rating = "По рейтингу"
}

/**
 General screen controller for Cart Screen
 */
final class CartViewController: UIViewController {
    // MARK: - View and variables

    private let orderId = "1"

    private var items: [Nft] = [] {
        didSet {
            didUpdateDataTable()
            didUpdateTotalInfo()
        }
    }

    lazy private var sortByButton: UIBarButtonItem = { [self] in
        guard let icon = UIImage(named: "filter-icon") else { return UIBarButtonItem() }
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(didTapSortByButton))
        button.tintColor = .asset(.black)

        return button
    }()

    lazy private var tableViewController: OrderDetailsTableViewController = {
        let tableViewController = OrderDetailsTableViewController()
        tableViewController.delegate = self

        let tableView = tableViewController.tableView!

        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableViewController
    }()

    lazy private var totalLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.textColor = .asset(.black)
        totalLabel.font = .caption1

        return totalLabel
    }()

    lazy private var totalCostLabel: UILabel = {
        let totalCostLabel = UILabel()
        totalCostLabel.translatesAutoresizingMaskIntoConstraints = false
        totalCostLabel.textColor = .asset(.green)
        totalCostLabel.font = .bodyBold

        return totalCostLabel
    }()

    lazy private var payButton: ButtonComponent = {
        let button = ButtonComponent(.primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("К оплате", for: .normal)

        return button
    }()

    lazy private var totalInfoView: UIStackView = {
        let totalInfoStackView = UIStackView(arrangedSubviews: [totalLabel, totalCostLabel])
        totalInfoStackView.translatesAutoresizingMaskIntoConstraints = false

        totalInfoStackView.axis = .vertical
        totalInfoStackView.distribution = .fillEqually

        return totalInfoStackView
    }()

    lazy private var totalView: UIStackView = {
        let totalStackView = UIStackView(arrangedSubviews: [totalInfoView, payButton])
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        totalStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        totalStackView.isLayoutMarginsRelativeArrangement = true

        totalStackView.backgroundColor = .asset(.lightGrey)
        totalStackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        totalStackView.layer.masksToBounds = true
        totalStackView.layer.cornerRadius = 16
        totalStackView.spacing = 24
        totalStackView.alignment = .top

        return totalStackView
    }()

    private var emptyItems: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "Корзина пуста"
        label.textColor = .asset(.black)
        label.font = .bodyBold
        label.textAlignment = .center
        label.layer.zPosition = 10

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = sortByButton

        view.addSubview(emptyItems)
        view.addSubview(tableViewController.tableView)
        view.addSubview(totalView)

        setupView()
        fetchData()
    }

    // MARK: - Actions

    @objc private func didTapSortByButton(sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()

        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        CartNftSortable.allCases.forEach {
            let sortCase = $0
            let action = UIAlertAction(title: $0.rawValue, style: .default) { [weak self] action in
                guard let self else { return }
                sortable(by: sortCase)
            }

            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))

        present(alertController, animated: true)
    }

    @objc private func didTapPayButton(sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        navigationController?.pushViewController(PayViewController(orderId: orderId), animated: true)
    }

    // MARK: - Private methods

    private func setupView() {
        payButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)

        NSLayoutConstraint.activate([
            // constraints for collection view
            tableViewController.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableViewController.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableViewController.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableViewController.tableView.bottomAnchor.constraint(equalTo: totalView.topAnchor),

            // constraints for footer
            totalView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            totalView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            totalView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            // empty message
            emptyItems.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyItems.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            emptyItems.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyItems.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}

// MARK: - Extensions

extension CartViewController {
    private func findBy(id: String) -> Nft? {
        if items.count == 0 {
            return nil
        }

        return items.first(where: { $0.id == id }) ?? nil
    }

    private func sortable(by: CartNftSortable) {
        items.sort { (lhs: Nft, rhs: Nft) -> Bool in
            switch by {
            case .name: return lhs.name < rhs.name
            case .price: return lhs.price < rhs.price
            case .rating: return lhs.rating < rhs.rating
            }
        }
    }
}

// MARK: - Update data and table method

extension CartViewController: UpdateCartViewProtocol {
    func didUpdateTotalInfo() {
        let costSum = String(format: "%.02f", items.reduce(0) { $0 + $1.price })

        totalLabel.text = "\(items.count) NFT"
        totalCostLabel.text = "\(costSum) ETH"

        //
        let isHidden = items.isEmpty

        totalView.isHidden = isHidden
        emptyItems.isHidden = !isHidden
        navigationItem.rightBarButtonItem = isHidden ? nil : sortByButton
    }

    func didUpdateDataTable() {
        tableViewController.items = items
    }

    func showConfirmDelete(itemId: String) {
        let item = findBy(id: itemId)
        guard let item else { return }

        let deleteVc = DeleteItemViewController(item: item)
        deleteVc.modalPresentationStyle = .overFullScreen
        deleteVc.delegate = self

        navigationController?.present(deleteVc, animated: true)
    }

    func fetchData(refreshControl: UIRefreshControl? = nil) {
        showLoader(isShow: true, refreshControl: refreshControl)

        items = []

        // load order data
        OrderNetworkModel.fetchData(id: orderId) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let order):
                // load nft data
                if order.nfts.count > 0 {
                    order.nfts.forEach { id in
                        NftNetworkModel.fetchData(id: id) { [weak self] result in
                            guard let self else { return }

                            switch result {
                            case .success(let nftNetworkModel):
                                let nft = Nft.make(by: nftNetworkModel)
                                self.items.append(nft)
                            case .failure (let error):
                                self.showLoader(isShow: false, refreshControl: refreshControl)

                                present(
                                    ErrorView.make(
                                        title: "Network Error",
                                        message: error.localizedDescription) { [weak self] in
                                            guard let self else { return }
                                            self.fetchData(refreshControl: refreshControl)
                                        }
                                    , animated: true)
                            }
                        }
                    }
                }

                // loading data is complete
                self.showLoader(isShow: false, refreshControl: refreshControl)
            case .failure(let error):
                self.showLoader(isShow: false, refreshControl: refreshControl)

                present(
                    ErrorView.make(
                        title: "Network Error",
                        message: error.localizedDescription) { [weak self] in
                            guard let self else { return }
                            self.fetchData(refreshControl: refreshControl)
                        }
                , animated: true)
            }
        }
    }

    func deleteItem(itemId: String) {
        let itemDelete = findBy(id: itemId)
        guard let itemDelete else { return }

        items = items.filter({ $0.id != itemDelete.id })

        let nfts_id: [String] = items.map({
            $0.id
        })

        OrderNetworkModel.updateData(id: orderId, nfts_id: nfts_id) { result in
            print("Send to server. Ok (placeholder)")
        }

    }

    func showLoader(isShow: Bool, refreshControl: UIRefreshControl?) {
        if let refreshControl = refreshControl {
            isShow
                ? refreshControl.beginRefreshing()
                : refreshControl.endRefreshing()
            return
        }

        if isShow {
            view.isUserInteractionEnabled = false
            ProgressHUD.show()
        } else {
            view.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
        }
    }
}
