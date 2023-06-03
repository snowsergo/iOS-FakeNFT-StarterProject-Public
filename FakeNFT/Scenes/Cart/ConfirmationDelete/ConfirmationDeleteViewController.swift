//
// Created by Сергей Махленко on 02.06.2023.
//

import UIKit

class ConfirmationDeleteViewController: UIViewController {

    private var viewModel: ConfirmationDeleteViewModel = {
        ConfirmationDeleteViewModel()
    }()

    // MARK: - UI elements

    private var previewImageView: UIImageView = {
        let imageView = ImageViewWithPreloading()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    lazy private var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .caption2
        label.textAlignment = .center
        label.text = "Вы уверены, что хотите\nудалить объект из корзины?"
        return label
    }()

    lazy private var removeButton: UIButton = {
        let button = ButtonComponent(.primary)
        button.titleLabel?.font = .bodyRegular
        button.setTitleColor(.asset(.red), for: .normal)
        button.setTitle("Удалить", for: .normal)
        button.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)
        return button
    }()

    lazy private var dismissButton: UIButton = {
        let button = ButtonComponent(.primary)
        button.titleLabel?.font = .bodyRegular
        button.setTitle("Вернуться", for: .normal)
        button.addTarget(self, action: #selector(didTapDismissScreen), for: .touchUpInside)
        return button
    }()

    lazy private var contentStackView: UIStackView = {
        let previewStackView = UIStackView(arrangedSubviews: [previewImageView, messageLabel])
        let actionsStackView = UIStackView(arrangedSubviews: [removeButton, dismissButton])
        let contentStackView = UIStackView(arrangedSubviews: [previewStackView, actionsStackView])

        [previewStackView, contentStackView].forEach({
            $0.axis = .vertical
            $0.alignment = .center
        })

        previewStackView.spacing = 12
        actionsStackView.spacing = 8
        contentStackView.spacing = 20

        return contentStackView
    }()

    // MARK: - Setup view

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupViewModel()
    }

    private func setupView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)

        view.addSubview(contentStackView)
    }

    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide

        [contentStackView, previewImageView].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })

        NSLayoutConstraint.activate([
            contentStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
        ])

        NSLayoutConstraint.activate([
            previewImageView.widthAnchor.constraint(equalToConstant: 108),
            previewImageView.heightAnchor.constraint(equalTo: previewImageView.widthAnchor, multiplier: 1)
        ])

        NSLayoutConstraint.activate([
            removeButton.widthAnchor.constraint(equalToConstant: 127),
            dismissButton.widthAnchor.constraint(equalToConstant: 127)
        ])
    }

    private func setupViewModel() {
    }

    // MARK: - Actions

    @objc private func didTapRemove() {
        // TODO: Add method remove
        dismiss(animated: true)
    }

    @objc private func didTapDismissScreen() {
        dismiss(animated: true)
    }
}
