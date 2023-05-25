import UIKit
import Kingfisher

final class OrderDetailsTableViewCell: UITableViewCell, ReuseIdentifying {
    var delegate: OrderTableCellDelegate?

    private var itemIndex: Int?

    let pictureView: UIImageView = {
        let pictureView = UIImageView()
        pictureView.translatesAutoresizingMaskIntoConstraints = false

        pictureView.backgroundColor = ColorScheme.lightGrey
        pictureView.clipsToBounds = true
        pictureView.layer.cornerRadius = 12

        return pictureView
    }()

    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .boldSystemFont(ofSize: 17)
        return nameLabel
    }()

    let starsView: StarsComponent = {
        StarsComponent()
    }()

    let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        priceLabel.font = .boldSystemFont(ofSize: 17)
        return priceLabel
    }()

    let priceTitleLabel: UILabel = {
        let priceTitleLabel = UILabel()
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        priceTitleLabel.text = "Цена"
        priceTitleLabel.font = .systemFont(ofSize: 14)
        
        return priceTitleLabel
    }()

    let deleteButton: UIButton = {
        let image = UIImage(named: "trash-icon") ?? UIImage(systemName: "trash")

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)

        return button
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setModel(_ model: Nft, itemIndex: Int) {
        self.itemIndex = itemIndex
        nameLabel.text = model.name
        priceLabel.text = "\(model.price) ETH"
        starsView.highlightStars(count: model.rating)

        if let imageUrlString = model.images.first {
            let url = URL(string: imageUrlString)!
            pictureView.kf.setImage(with: url)
        }
    }

    @objc private func didTapTrash() {
        guard let itemIndex = itemIndex else { return }

        if let delegate = delegate {
            DispatchQueue.main.async {
                delegate.didTapTrash(itemIndex: itemIndex)
            }
        }

    }

    private func setupView() {
        backgroundColor = ColorScheme.white
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none

        deleteButton.addTarget(self, action: #selector(didTapTrash), for: .touchUpInside)

        // content
        let nameAndStarsStackView = UIStackView(arrangedSubviews: [nameLabel, starsView])
        nameAndStarsStackView.axis = .vertical
        nameAndStarsStackView.spacing = 4

        let priceStackView = UIStackView(arrangedSubviews: [priceTitleLabel, priceLabel])
        priceStackView.axis = .vertical
        priceStackView.spacing = 4

        let contentStackView = UIStackView(arrangedSubviews: [nameAndStarsStackView, priceStackView])
        contentStackView.spacing = 20
        contentStackView.axis = .vertical
        contentStackView.alignment = .leading

        let cellStackView = UIStackView(arrangedSubviews: [pictureView, contentStackView, deleteButton])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.spacing = 20
        cellStackView.alignment = .center
        cellStackView.distribution = .fill

        addSubview(cellStackView)

        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            cellStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cellStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cellStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),

            pictureView.widthAnchor.constraint(equalToConstant: 108),
            pictureView.heightAnchor.constraint(equalTo: pictureView.widthAnchor, multiplier: 1),

            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor, multiplier: 1)
        ])
    }
}
