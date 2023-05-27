//
// Created by Сергей Махленко on 23.05.2023.
//

import UIKit

final class PayStatusViewController: UIViewController {

    private var isSuccessful: Bool = false
    private let orderId: String
    private let currencyId: String

    var delegate: PayStatusDelegate?

    private lazy var imageView: UIImageView = {
        let image: UIImage = isSuccessful
            ? .asset(.successPay)
            : .asset(.failurePay)

        let imageView = UIImageView(image: image)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var messageLabel: UILabel = { [self] in
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .headline3

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

    init(orderId: String, currencyId: String) {
        self.orderId = orderId
        self.currencyId = currencyId

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .asset(.white)

        checkoutPayment() { [weak self] isSuccessful in
            guard let self else { return }

            self.isSuccessful = isSuccessful

            view.addSubview(imageView)
            view.addSubview(messageLabel)
            view.addSubview(backButton)

            setupView()
        }
    }

    @objc func didTapBackButton(sender: Any) {
        return isSuccessful
            ? paySuccessful(sender)
            : payFailure(sender)
    }

    // MARK: - Private methods

    private func checkoutPayment(completeHandle: @escaping (_ isSuccessful: Bool) -> Void) {

        let networkClient = DefaultNetworkClient()
        let request = GetCheckoutPaymentRequest(orderId: orderId, currencyId: currencyId)

        networkClient.send(request: request, type: CheckoutPaymentNetworkModel.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completeHandle(response.success)
                case .failure:
                    completeHandle(false)
                }
            }
        }
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
        dismiss(animated: true)
    }

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
