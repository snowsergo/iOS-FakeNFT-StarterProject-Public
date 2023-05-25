//
// Created by Сергей Махленко on 24.05.2023.
//

import UIKit

final class DeleteItemViewController: UIViewController {

    private let item: Nft

    lazy private var preview: UIImageView = {
        let url = item.images.count > 0
            ? URL(string: item.images.first!)
            : nil

        return PreviewImageComponent(url: url)
    }()

    lazy private var confirmMessageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Вы уверены, что хотите\nудалить объект из корзины?"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.textColor = ColorScheme.black

        return label
    }()

    lazy private var backButton: UIButton = {
        let button = ButtonComponent(.primary, size: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Вернуться", for: .normal)
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        return button
    }()

    lazy private var confirmRemoveButton: UIButton = {
        let button = ButtonComponent(.primary, size: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить", for: .normal)
        button.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)
        button.setTitleColor(ColorScheme.red, for: .normal)

        return button
    }()

    init(item: Nft) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBlurFilter()
        setupView()
    }

    // MARK: - Action methods

    @objc private func didTapBack(sender: Any) {
        dismiss(animated: true)
    }

    @objc private func didTapRemove(sender: Any) {
        UISelectionFeedbackGenerator().selectionChanged()

        let alert = UIAlertController(title: "NFT удален", message: "Представьте что он удален 😁", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ок, представлю", style: .default) { [weak self] action in
            guard let self else { return }
            dismiss(animated: true)
        })

        present(alert, animated: true)
    }

    // MARK: - Private methods

    private func setupBlurFilter() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }

    private func setupView() {
        //
        let actionButtonsRow = UIStackView(arrangedSubviews: [confirmRemoveButton, backButton])
        actionButtonsRow.translatesAutoresizingMaskIntoConstraints = false
        actionButtonsRow.spacing = 8

        let contentContainer = UIStackView(arrangedSubviews: [preview, confirmMessageLabel, actionButtonsRow])
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.axis = .vertical
        contentContainer.spacing = 12
        contentContainer.alignment = .center

        view.addSubview(contentContainer)

        // constraints
        NSLayoutConstraint.activate([
            contentContainer.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentContainer.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            preview.widthAnchor.constraint(equalToConstant: 108),
            preview.heightAnchor.constraint(equalTo: preview.widthAnchor, multiplier: 1)
        ])
    }
}
