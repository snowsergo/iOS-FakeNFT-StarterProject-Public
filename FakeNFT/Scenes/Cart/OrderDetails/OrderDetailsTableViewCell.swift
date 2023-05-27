import UIKit
import Kingfisher

final class OrderDetailsTableViewCell: UITableViewCell, ReuseIdentifying {
    var delegate: UpdateCartViewProtocol?

    private var model: Nft?

    lazy private var pictureView: PreviewImageView = PreviewImageView(url: nil)

    let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .bodyBold
        return nameLabel
    }()

    let starsView: StarsComponent = StarsComponent()

    let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        priceLabel.font = .bodyBold
        return priceLabel
    }()

    let priceTitleLabel: UILabel = {
        let priceTitleLabel = UILabel()
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        priceTitleLabel.text = "Цена"
        priceTitleLabel.font = .caption2
        
        return priceTitleLabel
    }()

    let confirmDeleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.asset(.trash), for: .normal)

        return button
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setModel(_ model: Nft) {
        self.model = model

        nameLabel.text = model.name
        priceLabel.text = "\(model.price) ETH"
        starsView.highlightStars(count: model.rating)

        if let imageUrlString = model.images.first {
            let url = URL(string: imageUrlString)!
            pictureView.load(url: url)
        }
    }

    @objc private func didTapConfirmShow() {
        UISelectionFeedbackGenerator().selectionChanged()

        if let delegate = delegate {
            DispatchQueue.main.async { [weak self] in
                guard let self, let model else { return }
                delegate.showConfirmDelete(itemId: model.id)
            }
        }
    }

    private func setupView() {
        backgroundColor = .asset(.white)
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none

        confirmDeleteButton.addTarget(self, action: #selector(didTapConfirmShow), for: .touchUpInside)

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

        let cellStackView = UIStackView(arrangedSubviews: [pictureView, contentStackView, confirmDeleteButton])
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

            confirmDeleteButton.widthAnchor.constraint(equalToConstant: 40),
            confirmDeleteButton.heightAnchor.constraint(equalTo: confirmDeleteButton.widthAnchor, multiplier: 1)
        ])
    }
}
