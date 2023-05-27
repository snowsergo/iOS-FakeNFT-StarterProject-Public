//
// Created by Сергей Махленко on 23.05.2023.
//

import UIKit

final class PayStatusViewController: UIViewController {

    private let isSuccessful: Bool

    var delegate: PayStatusDelegate?

    private lazy var imageView: UIImageView = { [self] in
        let imageName = isSuccessful ? "success-pay-status" : "failure-pay-status"

        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var messageLabel: UILabel = { [self] in
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .boldSystemFont(ofSize: 22)

        messageLabel.text = isSuccessful
            ? "Успех! Оплата прошла,\nпоздравляем с покупкой!"
            : "Упс! Что-то пошло не так :(\nПопробуйте ещё раз!"

        return messageLabel
    }()

    private lazy var backButton: UIButton = { [self] in
        let backButton = ButtonComponent(.primary, size: .large)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        backButton.setTitle(
            isSuccessful
                ? "Вернуться в каталог"
                : "Попробовать еще раз",
            for: .normal)

        return backButton
    }()

    init(isSuccessful: Bool) {
        self.isSuccessful = isSuccessful
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .asset(.white)

        view.addSubview(imageView)
        view.addSubview(messageLabel)
        view.addSubview(backButton)

        setupView()
    }

    @objc func didTapBackButton(sender: Any) {
        isSuccessful
            ? paySuccessful(sender)
            : payFailure(sender)
    }

    private func paySuccessful(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()

        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            delegate?.didSuccessful()
        }
    }

    private func payFailure(_ sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()

        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            delegate?.didFailure()
        }

    }

    // MARK: - Private methods

    private func setupView() {
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -56),
            imageView.widthAnchor.constraint(equalToConstant: 278),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),

            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            messageLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),

            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            backButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
