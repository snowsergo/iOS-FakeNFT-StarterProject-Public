//
// Created by Сергей Махленко on 02.06.2023.
//

import UIKit

class CartViewController: UIViewController {

    private let orderId: String = "2"

    private var viewModel: CartViewModel = {
        CartViewModel()
    }()

    // MARK - UI Elements

    lazy private var itemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(NftViewCell.self)
        tableView.backgroundColor = .asset(.white)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.separatorStyle = .none
        return tableView
    }()

    private var totalCountLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .asset(.black)
        label.text = "20 NFT"
        return label
    }()

    private var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .asset(.green)
        label.text = "12.23 ETH"
        return label
    }()

    lazy private var cartInfoStackView: UIStackView = {
        let totalStackView = UIStackView(arrangedSubviews: [totalCountLabel, totalPriceLabel])
        totalStackView.axis = .vertical
        totalStackView.spacing = 2

        let stackView = UIStackView(arrangedSubviews: [totalStackView, paymentButton])
        stackView.backgroundColor = .asset(.lightGray)
        stackView.spacing = 24

        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true

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
        let button = UIBarButtonItem(image: .asset(.sort), style: .plain, target: self, action: nil)
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

        emptyMessageLabel.isHidden = true
    }

    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            emptyMessageLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            emptyMessageLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            emptyMessageLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            emptyMessageLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
        ])

        NSLayoutConstraint.activate([
            cartInfoStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            cartInfoStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            cartInfoStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            itemsTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            itemsTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            itemsTableView.bottomAnchor.constraint(equalTo: cartInfoStackView.topAnchor),
            itemsTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
        ])
    }

    private func setupViewModel() {}
}

// MARK - Extensions

extension CartViewController {
    private func deleteTapHandle() {
        let confirmationDeleteViewController = ConfirmationDeleteViewController()
        confirmationDeleteViewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(confirmationDeleteViewController, animated: true)
    }

    @objc private func didTapPaymentShow() {
        let paymentViewController = PaymentViewController()
        navigationController?.pushViewController(paymentViewController, animated: true)
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NftViewCell = tableView.dequeueReusableCell()

        cell.setup { [weak self] in
            self?.deleteTapHandle()
        }

        return cell
    }
}
