//
// Created by Сергей Махленко on 21.05.2023.
//

import UIKit

protocol PayStatusDelegate {
    func didSuccessful()
    func didFailure()
}

final class PayViewController: UIViewController {
    // TODO: - Заменить на коллекцию
    private let collectionView: UIView = {
        let collection = UIView()
        collection.translatesAutoresizingMaskIntoConstraints = false

        return collection
    }()

    private let footerTextLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.text = "Совершая покупку, вы соглашаетесь с условиями"
        textLabel.font = .caption2

        return textLabel
    }()

    private let userAgreementLabel: UILabel = {
        let linkLabel = UILabel()
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.isUserInteractionEnabled = true
        linkLabel.text = "Пользовательского соглашения"
        linkLabel.textColor = .asset(.black)
        linkLabel.font = .caption2

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

        footerView.addSubview(footerTextLabel)
        footerView.addSubview(userAgreementLabel)
        footerView.addSubview(payButton)
        view.addSubview(footerView)
        view.addSubview(collectionView)

        view.backgroundColor = .asset(.white)
        navigationItem.backButtonTitle = ""

        setupView()
    }

    // MARK: - Private methods

    private func setupView() {
        // Targets
        payButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)

        let didTapAgreement = UITapGestureRecognizer(target: self, action: #selector(didTapAgreement))
        userAgreementLabel.addGestureRecognizer(didTapAgreement)

        NSLayoutConstraint.activate([
            footerTextLabel.topAnchor.constraint(equalTo: footerView.topAnchor),
            footerTextLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            footerTextLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),

            userAgreementLabel.topAnchor.constraint(equalTo: footerTextLabel.bottomAnchor, constant: 4),
            userAgreementLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            userAgreementLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),

            payButton.topAnchor.constraint(equalTo: userAgreementLabel.topAnchor, constant: 36),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),

            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    @objc private func didTapPayButton() {
        UISelectionFeedbackGenerator().selectionChanged()
        let payStatusController = PayStatusViewController(isSuccessful: Bool.random())
        payStatusController.modalPresentationStyle = .fullScreen
        payStatusController.delegate = self

        present(payStatusController, animated: true)
    }

    @objc private func didTapAgreement(sender: UITapGestureRecognizer) {
        let vc = WebViewController(url: "https://yandex.ru/legal/practicum_termsofuse")
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PayViewController: PayStatusDelegate {
    func didSuccessful() {
        navigationController?.popToRootViewController(animated: false)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.rootTabBarController.selectedIndex = 1
    }

    func didFailure() {
    }
}
