import UIKit
import Kingfisher

final class StatisticsNftCell: UICollectionViewCell {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }

    override func prepareForReuse() {
        configure(with: nil)
    }

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like"), for: .normal)

        button.tintColor = .asset(.white)
        button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var bucketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bucket"), for: .normal)
        button.tintColor = .asset(.white)
        button.addTarget(self, action: #selector(bucketTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var imageBackground: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .asset(.black)
        return view
    }()
    let ratingView = RatingView()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .asset(.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .asset(.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

}

extension StatisticsNftCell {
    func configure(with nft: Nft?) {
        nameLabel.text = nft?.name
        ratingView.rating = nft?.rating
        if let price = nft?.price {
            priceLabel.text = String(price)
        } else {
            priceLabel.text = "?"
        }
        ratingView.rating = nft?.rating

        guard let url = nft?.images[0], let validUrl = URL(string: url) else {return}
        let processor = RoundCornerImageProcessor(cornerRadius: 12)
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ]
        imageBackground.kf.setImage(with: validUrl, options: options)
    }

}

private extension StatisticsNftCell {
    @objc func likeTapped() {
        print("likeTapped")
    }

    @objc func bucketTapped() {
        print("bucketTapped")
    }

}

private extension StatisticsNftCell {
    func setupAppearance() {
        contentView.addSubview(imageBackground)
        contentView.addSubview(ratingView)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        contentView.addSubview(bucketButton)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)

        NSLayoutConstraint.activate([
            imageBackground.topAnchor.constraint(equalTo: topAnchor),
            imageBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageBackground.heightAnchor.constraint(equalTo: widthAnchor),

            likeButton.topAnchor.constraint(equalTo: imageBackground.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: imageBackground.trailingAnchor, constant: -8),

            ratingView.topAnchor.constraint(equalTo: imageBackground.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            nameLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 6),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),

            bucketButton.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 16),
            bucketButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)

        ])
    }
}
