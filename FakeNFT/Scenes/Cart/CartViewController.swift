//
// Created by Сергей Махленко on 02.06.2023.
//

import UIKit
import ProgressHUD

final class CartViewController: UIViewController {

    private let orderId: String = Config.mockOrderId

    private var viewModel: CartViewModel = {
        CartViewModel(networkClient: DefaultNetworkClient())
    }()

    // MARK - UI Elements

    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()

    lazy private var itemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(NftViewCell.self)
        tableView.backgroundColor = .asset(.white)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: .padding(.large), left: 0, bottom: .padding(.large), right: 0)
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl

        return tableView
    }()

    private var totalCountLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .asset(.black)
        return label
    }()

    private var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .asset(.green)
        return label
    }()

    lazy private var cartInfoStackView: UIStackView = {
        let totalStackView = UIStackView(arrangedSubviews: [totalCountLabel, totalPriceLabel])
        totalStackView.axis = .vertical
        totalStackView.spacing = 2

        let stackView = UIStackView(arrangedSubviews: [totalStackView, paymentButton])
        stackView.backgroundColor = .asset(.lightGray)
        stackView.spacing = 24

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: .padding(.standard),
            left: .padding(.standard),
            bottom: .padding(.standard),
            right: .padding(.standard))

        stackView.layer.cornerRadius = 16
        stackView.layer.masksToBounds = true
        stackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return stackView
    }()

    lazy private var paymentButton: UIButton = {
        let button = ButtonComponent(.primary) as UIButton
        button.setTitle("К оплате", for: .normal)
        button.addTarget(self, action: #selector(didTapPaymentShow), for: .touchUpInside)
        return button
    }()

    lazy private var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: .asset(.sort),
            style: .plain,
            target: self,
            action: #selector(didTapSort))
        button.tintColor = .asset(.black)
        return button
    }()

    lazy private var emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .asset(.black)
        label.textAlignment = .center
        label.text = "Корзина пуста"
        return label
    }()

    // MARK: - Setup view

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupViewModel()
    }

    private func setupView() {
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = sortButton

        [itemsTableView, cartInfoStackView, emptyMessageLabel].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        })

        toggleEmptyTable(true)
    }

    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            emptyMessageLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            emptyMessageLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            emptyMessageLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: .padding(.standardInverse)),
            emptyMessageLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .padding(.standard))
        ])

        NSLayoutConstraint.activate([
            cartInfoStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            cartInfoStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            cartInfoStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            itemsTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            itemsTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            itemsTableView.bottomAnchor.constraint(equalTo: cartInfoStackView.topAnchor),
            itemsTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        ])
    }

    private func setupViewModel() {
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }

                let isEmpty = self.viewModel.numberOfCells == 0

                self.toggleEmptyTable(isEmpty)
                self.updateCartInfo()
                self.itemsTableView.reloadData()
            }
        }

        viewModel.removeTableCellClosure = { [weak self] (indexPath: IndexPath) in
            DispatchQueue.main.async {
                guard let self else { return }

                let isEmpty = self.viewModel.numberOfCells == 0
                self.toggleEmptyTable(isEmpty)
                self.updateCartInfo()

                self.itemsTableView.deleteRows(at: [indexPath], with: .left)
            }
        }

        viewModel.updateLoadingStatus = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                if self.itemsTableView.refreshControl?.isRefreshing == true {
                    return self.refreshShowLoading(self.viewModel.isLoading)
                }

                self.defaultShowLoading(self.viewModel.isLoading)
            }
        }

        viewModel.showAlertClosure = { [weak self] in
            guard let self else { return }

            DispatchQueue.main.async {
                let titleText = "Упс! У нас ошибка."
                let messageText = self.viewModel.errorMessage ?? "Unknown error"

                let alert = RepeatAlertMaker.make(title: titleText, message: messageText) {
                    self.viewModel.fetchOrder(id: self.orderId)
                }

                self.present(alert, animated: true)
            }
        }

        viewModel.fetchOrder(id: orderId)
    }
}

// MARK - Extensions

extension CartViewController {
    private func toggleEmptyTable(_ isEmpty: Bool) {
        emptyMessageLabel.isHidden = !isEmpty
        cartInfoStackView.isHidden = isEmpty
        navigationItem.rightBarButtonItem = isEmpty ? nil : sortButton
    }

    private func updateCartInfo() {
        totalCountLabel.text = "\(viewModel.numberOfCells) NFT"
        totalPriceLabel.text = "\(viewModel.totalPriceCells) ETH"
    }

    private func deleteTapHandle(at indexPath: IndexPath) {
        guard let order = viewModel.order else { return }

        let item = viewModel.getCellViewModel(at: indexPath)

        let confirmationDeleteViewController = ConfirmationDeleteViewController(order: order, item: item)
        confirmationDeleteViewController.modalPresentationStyle = .overFullScreen

        confirmationDeleteViewController.completeRemoveClosure = {
            confirmationDeleteViewController.dismiss(animated: true)
            DispatchQueue.main.async { [weak self] in
                self?.viewModel.removeCellViewModel(at: indexPath)
            }
        }

        navigationController?.present(confirmationDeleteViewController, animated: true)
    }

    private func refreshShowLoading(_ isLoading: Bool) {
        isLoading ? refreshControl.beginRefreshing() : refreshControl.endRefreshing()
        view.isUserInteractionEnabled = !isLoading
    }

    private func defaultShowLoading(_ isLoading: Bool) {
        isLoading ? ProgressHUD.show() : ProgressHUD.dismiss()
        view.isUserInteractionEnabled = !isLoading
    }

    @objc private func didTapSort() {
        let alertController = UIAlertController()

        SortType.allCases.forEach { type in
            alertController.addAction(
                UIAlertAction(title: type.rawValue, style: .default) { [weak self] _ in
                    self?.viewModel.sort(by: type)
                }
            )
        }

        alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        present(alertController, animated: true)
    }

    @objc private func didTapPaymentShow() {
        let paymentViewController = PaymentViewController()
        navigationController?.pushViewController(paymentViewController, animated: true)
    }

    @objc private func refreshData() {
        viewModel.fetchOrder(id: orderId)
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NftViewCell = tableView.dequeueReusableCell()
        let nft = viewModel.getCellViewModel(at: indexPath)

        cell.setup(nft: nft) {[weak self] in
            self?.deleteTapHandle(at: indexPath)
        }

        return cell
    }
}
