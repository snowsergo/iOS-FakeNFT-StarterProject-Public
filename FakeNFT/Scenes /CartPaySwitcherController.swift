//
// Created by Сергей Махленко on 21.05.2023.
//

import UIKit

final class CartPaySwitcherController: UIViewController {

    // TODO: - Заменить на коллекцию
    private let collectionView: UIView = {
        let collection = UIView()
        collection.translatesAutoresizingMaskIntoConstraints = false

        return collection
    }()

    private let footerTextLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = "Совершая покупку, вы соглашаетесь с условиями"

        return textLabel
    }()

    private let userAgreementLabel: UILabel = {
        let linkLabel = UILabel()
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.text = "Пользовательского соглашения"
        linkLabel.textColor = .link

        return linkLabel
    }()

    private let payButton: UIButton = {
        let buttonView = ButtonComponent(.primary, size: .large)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.setTitle("Оплатить", for: .normal)

        return buttonView
    }()

    private let footerView: UIView = {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false

        return footerView
    }()

    override func viewDidLoad() {
        title = "Выберите способ оплаты"
        view.backgroundColor = .background

        let backButton = UIBarButtonItem(
                image: UIImage(systemName: "chevron.backward"),
                style: .plain,
                target: self,
                action: #selector(didTapDismiss))
        backButton.tintColor = .primary

        navigationItem.leftBarButtonItem = backButton

        setup()
    }

    // MARK: - Private methods

    private func setup() {
        view.addSubview(collectionView)

        footerView.addSubview(footerTextLabel)
        footerView.addSubview(userAgreementLabel)
        footerView.addSubview(payButton)
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            footerTextLabel.topAnchor.constraint(equalTo: footerView.topAnchor),
            footerTextLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            footerTextLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),

            userAgreementLabel.topAnchor.constraint(equalTo: footerTextLabel.bottomAnchor, constant: 4),
            userAgreementLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            userAgreementLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),

            payButton.topAnchor.constraint(equalTo: userAgreementLabel.topAnchor, constant: 36),
            payButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),

            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 120),

            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    @objc private func didTapDismiss() {
        dismiss(animated: true)
    }
}
