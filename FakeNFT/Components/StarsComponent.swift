//
// Created by Сергей Махленко on 24.05.2023.
//

import UIKit

final class StarsComponent: UIView {

    lazy private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.alignment = .center
        stack.distribution = .fillEqually

        return stack
    }()

    private let maximumStars = 5

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func highlightStars(count: Int) {
        guard count >= 0 && count <= maximumStars else { return }

        for index in 0..<maximumStars {
            stackView.arrangedSubviews[index].tintColor = index < count
                ? ColorScheme.yellow
                : ColorScheme.lightGrey
        }
    }

    // MARK: - Private methods

    private func setupView() {
        let starImage = UIImage(systemName: "star.fill")

        for _ in 0..<maximumStars {
            let starImageView = UIImageView(image: starImage)
            starImageView.tintColor = ColorScheme.lightGrey
            stackView.addArrangedSubview(starImageView)

            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 12),
                starImageView.heightAnchor.constraint(equalToConstant: 11.25)
            ])
        }

        addSubview(stackView)
    }
}
