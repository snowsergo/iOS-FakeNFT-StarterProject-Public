//
// Created by Сергей Махленко on 03.06.2023.
//

import UIKit

class PaySuccessfulViewController: UIViewController {
    var didComplete: (() -> Void)?

    // MARK: - UI elements

    private let pictureView: UIImageView = {
        let image = UIImageView(image: .asset(.successPay))
        return image
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .asset(.black)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Успех! Оплата прошла,\nпоздравляем с покупкой!"
        return label
    }()

    lazy private var completeButton: ButtonComponent = {
        let button = ButtonComponent(.primary, size: .large)
        button.setTitle("Вернуться в каталог", for: .normal)
        button.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
        return button
    }()

    lazy private var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pictureView, messageLabel])
        stackView.axis = .vertical
        stackView.spacing = .padding(.large)
        return stackView
    }()

    // MARK: - Setup view

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }

    func setupView() {
        view.backgroundColor = .asset(.white)

        view.addSubview(contentStackView)
        view.addSubview(completeButton)
    }

    func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide

        [contentStackView, completeButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            contentStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            completeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            completeButton.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: .padding(.standard)),

            completeButton.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: .padding(.standardInverse))
        ])
    }
}

extension PaySuccessfulViewController {
    @objc func didTapComplete() {
        dismiss(animated: true) { [weak self] in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.rootTabBarController?.selectedIndex = 1
            self?.didComplete?()
        }
    }
}
