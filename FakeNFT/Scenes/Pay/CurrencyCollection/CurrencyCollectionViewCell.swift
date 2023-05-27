//
// Created by Сергей Махленко on 27.05.2023.
//

import UIKit

class CurrencyCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 1 : 0
        }
    }

    lazy private var iconView: CurrencyIconView = {
        let icon = CurrencyIconView(url: nil)
        icon.translatesAutoresizingMaskIntoConstraints = false

        return icon
    }()

    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .asset(.black)
        label.font = .caption2

        return label
    }()

    lazy private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .asset(.green)
        label.font = .caption2

        return label
    }()

    lazy private var infoStackView: UIStackView = {
        let infoStackView = UIStackView(arrangedSubviews: [ titleLabel, nameLabel ])
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.axis = .vertical
        infoStackView.spacing = 0

        infoStackView.alignment = .leading
        infoStackView.distribution = .equalCentering

        return infoStackView
    }()

    lazy private var cellStackView: UIStackView = {
        let cellStackView = UIStackView(arrangedSubviews: [ iconView, infoStackView ])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.spacing = 4
        cellStackView.alignment = .center
        cellStackView.distribution = .fillProportionally
        cellStackView.layoutMargins = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        cellStackView.isLayoutMarginsRelativeArrangement = true

        return cellStackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .asset(.lightGrey)

        layer.borderColor = UIColor.asset(.black).cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 12

        contentView.addSubview(cellStackView)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setModel(model: CurrencyNetworkModel) {
        titleLabel.text = model.title
        nameLabel.text = model.name
        if let url = URL(string: model.image) {
            iconView.load(url: url)
        }
    }

    private func setupView() {
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            iconView.widthAnchor.constraint(equalToConstant: 36),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor, multiplier: 1)
        ])
    }
}
