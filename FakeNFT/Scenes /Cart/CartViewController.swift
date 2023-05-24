//
// Created by Сергей Махленко on 18.05.2023.
//

import UIKit

protocol OrderTableCellDelegate {
    func didTapTrash(itemIndex: Int)
}

/**
 General screen controller for Cart Screen
 */
final class CartViewController: UIViewController {
    // MARK: - Initial default variables

    private var items: [Nft] = []

    lazy private var sortByButton: UIBarButtonItem = { [self] in
        guard let icon = UIImage(named: "filter-icon") else { return UIBarButtonItem() }
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(didTapSortByButton))
        button.tintColor = ColorScheme.black

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
        totalLabel.textColor = ColorScheme.black
        totalLabel.font = .systemFont(ofSize: 15)

        return totalLabel
    }()

    lazy private var totalCostLabel: UILabel = {
        let totalCostLabel = UILabel()
        totalCostLabel.translatesAutoresizingMaskIntoConstraints = false
        totalCostLabel.textColor = ColorScheme.green
        totalCostLabel.font = .boldSystemFont(ofSize: 17)

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

        totalStackView.backgroundColor = ColorScheme.lightGrey
        totalStackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        totalStackView.layer.masksToBounds = true
        totalStackView.layer.cornerRadius = 16
        totalStackView.spacing = 24
        totalStackView.alignment = .top

        return totalStackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = sortByButton

        view.addSubview(tableViewController.tableView)
        view.addSubview(totalView)

        setupView()
        fetchData()
    }

    // MARK: - Actions

    @objc private func didTapSortByButton(sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()

        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        let actions: [UIAlertAction] = [
            UIAlertAction(title: "По цене", style: .default) { action in
                print("Выбрана сортировка: \(action.title!)")
            },
            UIAlertAction(title: "По рейтингу", style: .default) { action in
                print("Выбрана сортировка: \(action.title!)")
            },
            UIAlertAction(title: "По названию", style: .default) { action in
                print("Выбрана сортировка: \(action.title!)")
            },
            UIAlertAction(title: "Закрыть", style: .cancel)
        ]

        actions.forEach { action in
            alertController.addAction(action)
        }

        present(alertController, animated: true)
    }

    @objc private func didTapPayButton(sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()
        navigationController?.pushViewController(PayViewController(), animated: true)
    }

    // MARK: - Mock items

    private func fetchData() {
        items = [
            Nft(
                createdAt: Date(),
                name: "April",
                images: [
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png",
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png",
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png"
                ],
                rating: 3,
                description: "A 3D model of a mythical creature.",
                price: 0.95,
                id: "1"),

            Nft(
                createdAt: Date(),
                name: "Aurora",
                images: [
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Aurora/1.png",
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Aurora/2.png",
                    "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Aurora/3.png"
                ],
                rating: 4,
                description: "An abstract painting of a fiery sunset.",
                price: 5.62,
                id: "2")
        ]

        totalLabel.text = "\(items.count) NFT"
        totalCostLabel.text = "\(items.reduce(0) { $0 + $1.price }) ETH"

        tableViewController.items = items
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
        ])
    }
}

extension CartViewController: OrderTableCellDelegate {
    func didTapTrash(itemIndex: Int) {
        let deleteVc = DeleteItemViewController(item: items[itemIndex])
        deleteVc.modalPresentationStyle = .overFullScreen

        //view.addSubview(deleteVc.view)
        //present(deleteVc, animated: true)
        navigationController?.present(deleteVc, animated: true)
    }
}
