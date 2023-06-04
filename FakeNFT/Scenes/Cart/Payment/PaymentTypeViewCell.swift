//
// Created by Сергей Махленко on 03.06.2023.
//

import UIKit

class PaymentTypeViewCell: UICollectionViewCell, ReuseIdentifying {
    override var isSelected: Bool {
        didSet {
            toggleSelectedState()
        }
    }

    // MARK: - UI elements

    lazy private var iconImageView: ImageViewWithPreloading = {
        let imageView = ImageViewWithPreloading()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.backgroundColor = .asset(.blackUniversal)
        return imageView
    }()

    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .asset(.black)
        label.text = "Tron"
        return label
    }()

    lazy private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .asset(.green)
        label.text = "TRX"
        return label
    }()

    lazy private var cellStackView: UIStackView = {
        let nameStackView = UIStackView(arrangedSubviews: [titleLabel, nameLabel])
        let cellStackView = UIStackView(arrangedSubviews: [iconImageView, nameStackView])
        nameStackView.axis = .vertical
        nameStackView.spacing = 4
        cellStackView.spacing = 4
        cellStackView.alignment = .center
        return cellStackView
    }()

    // MARK: - Setup view

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.backgroundColor = .asset(.lightGray)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 12
        contentView.layer.borderColor = UIColor.asset(.black).cgColor
        contentView.layer.borderWidth = 0.0

        contentView.addSubview(cellStackView)
    }

    private func setupLayout() {
        let safeArea = contentView.safeAreaLayoutGuide

        [cellStackView, iconImageView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            cellStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
            cellStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5),
            cellStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12)
        ])

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor, multiplier: 1)
        ])
    }

    func setup(model: Currency) {
        titleLabel.text = model.title
        nameLabel.text = model.name
        iconImageView.load(url: URL(string: model.image))
    }

    // MARK: Actions

    func toggleSelectedState() {
        let width = isSelected ? 1.0 : 0.0
        contentView.layer.borderWidth = width
    }
}
