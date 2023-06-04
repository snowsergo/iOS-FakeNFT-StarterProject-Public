//
// Created by Сергей Махленко on 03.06.2023.
//

import UIKit

class PayFailureViewController: UIViewController, PaymentStatusProtocol {

    var didComplete: (() -> Void)?

    // MARK: - UI elements

    private let pictureView: UIImageView = {
        let image = UIImageView(image: .asset(.failurePay))
        return image
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .asset(.black)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Упс! Что-то пошло не так :(\nПопробуйте ещё раз!"
        return label
    }()

    private let completeButton: ButtonComponent = {
        let button = ButtonComponent(.primary, size: .large)
        button.setTitle("Попробовать еще раз", for: .normal)
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

        [contentStackView, completeButton].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })

        NSLayoutConstraint.activate([
            contentStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            completeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            completeButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .padding(.standard)),
            completeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: .padding(.standardInverse))
        ])
    }
}

extension PayFailureViewController {
    @objc func didTapComplete() {
        didComplete?()
    }
}
