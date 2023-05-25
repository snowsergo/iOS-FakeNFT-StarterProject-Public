//
// Created by Сергей Махленко on 24.05.2023.
//

import UIKit

final class DeleteItemViewController: UIViewController {

    private let item: Nft

    lazy private var backButton: UIButton = {
        let button = ButtonComponent(.primary, size: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Вернуться", for: .normal)
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
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

        view.addSubview(backButton)

        setupView()
    }

    // MARK: - Private methods

    @objc private func didTapBack(sender: Any) {
        dismiss(animated: true)
    }

    private func setupBlurFilter() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }

    private func setupView() {
        // constraints
        NSLayoutConstraint.activate([
            backButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            backButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}
