//
// Created by Сергей Махленко on 18.05.2023.
//

import UIKit

/**
 General screen controller for Cart Screen
 */
final class CartViewController: UIViewController {
    // MARK: - Initial default variables

    private let sortByButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("...", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.backgroundColor = .systemGray6
        return button
    }()

    private let payButton: ButtonComponent = {
        let button = ButtonComponent(.primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("К оплате", for: .normal)

        return button
    }()

    private let tableViewController: OrderDetailsTableViewController = {
        let tableViewController = OrderDetailsTableViewController()
        let tableView = tableViewController.tableView!

        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableViewController
    }()

    private let footerView: UIView = {
        let footerView = UIView()

        footerView.backgroundColor = .systemBackground
        footerView.translatesAutoresizingMaskIntoConstraints = false

        footerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        footerView.layer.cornerRadius = 16

        return footerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.subviews.forEach({ $0.removeFromSuperview() })

        view.addSubview(sortByButton)
        view.addSubview(tableViewController.tableView)
        view.addSubview(footerView)

        // setup
        sortByButton.addTarget(self, action: #selector(didTapSortByButton), for: .touchUpInside)

        // pay button
        payButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        footerView.addSubview(payButton)
        NSLayoutConstraint.activate([
            payButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -16)
        ])

        setupConstraints()
    }

    // MARK: - Actions

    @objc private func didTapSortByButton(sender: Any) {
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
        let navigationController = UINavigationController(
                rootViewController: CartPaySwitcherController())

        navigationController.hidesBarsOnSwipe = true
        navigationController.modalPresentationStyle = .fullScreen

        present(navigationController, animated: true)
    }

    // MARK: - Private methods

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // constraints for filter button
            sortByButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sortByButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            sortByButton.widthAnchor.constraint(equalToConstant: 42),
            sortByButton.heightAnchor.constraint(equalToConstant: 42),

            // constraints for collection view
            tableViewController.tableView.topAnchor.constraint(equalTo: sortByButton.bottomAnchor),
            tableViewController.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableViewController.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableViewController.tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),

            // constraints for footer
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
