//
// Created by Сергей Махленко on 18.05.2023.
//

import UIKit

/**
 General screen controller for Cart Screen
 */
final class CartViewController: UIViewController {

    let sortByButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Фильтр", for: .normal)
        button.backgroundColor = .systemGray3
        return button
    }()

    let collectionView: UIView = {
        let collectionView = UIView()
        collectionView.backgroundColor = .systemGray2
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    let footerView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .systemGray
        footerView.translatesAutoresizingMaskIntoConstraints = false
        return footerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.subviews.forEach({ $0.removeFromSuperview() })

        view.backgroundColor = .systemGray6

        view.addSubview(sortByButton)
        view.addSubview(collectionView)
        view.addSubview(footerView)

        sortByButton.addTarget(self, action: #selector(sortByButtonTouchAction), for: .touchUpInside)

        setupConstraints()
    }

    // MARK: - @IBActions

    @objc func sortByButtonTouchAction(sender: Any) {
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

    // MARK: - Private methods

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // constraints for filter button
            sortByButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sortByButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            sortByButton.widthAnchor.constraint(equalToConstant: 42),
            sortByButton.heightAnchor.constraint(equalToConstant: 42),

            // constraints for collection view
            collectionView.topAnchor.constraint(equalTo: sortByButton.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: footerView.topAnchor),

            // constraints for footer
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
