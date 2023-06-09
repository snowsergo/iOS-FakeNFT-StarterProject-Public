import UIKit

final class NFTItemCell: UICollectionViewCell {
    static let reuseIdentifier = "nftItemCell"
    
    private var cartTapHandle: (() -> Void)?
    private var likeTapHandle: (() -> Void)?
    var viewModel: NFTCollectionNFTItem? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            if let url = URLEncoder(url: viewModel.image).encodedURL {
                nftImage.load(url: url)
            }
            renderRatingView(view: nftRatingView, value: viewModel.rating)
            nftName.text = viewModel.name
            nftPrice.text = viewModel.price.removeZerosFromEnd() + " " + CryptoCoin.ETH.rawValue
            
            if viewModel.liked {
                likeButton.setImage(UIImage(named: "like"), for: .normal)
            } else {
                likeButton.setImage(UIImage(named: "noLike"), for: .normal)
            }
            
            if viewModel.inCart {
                cartButton.setImage(UIImage(named: "removeFromCart"), for: .normal)
            } else {
                cartButton.setImage(UIImage(named: "addToCart"), for: .normal)
            }
        }
    }
    
    private let nftImage: ImageViewWithPreloading = {
        let view = ImageViewWithPreloading()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nftRatingView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nftNameAndPriceView = UIViewAutoLayout()
    
    private let nftName = StylizedLabel(style: .nftCollectionNameInNFTCollectionList)
    private let nftPrice = StylizedLabel(style: .priceInNFTCell)
    
    lazy private var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addToCart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCart), for: .touchUpInside)
        return button
    }()
    
    lazy private var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like"), for: .normal)
        button.imageView?.tintColor = UIColor(hexString: "#F56B6C")
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nftImage)
        contentView.addSubview(nftRatingView)
        contentView.addSubview(nftNameAndPriceView)
        nftNameAndPriceView.addSubview(nftName)
        nftNameAndPriceView.addSubview(nftPrice)
        contentView.addSubview(cartButton)
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            nftImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImage.heightAnchor.constraint(equalTo: nftImage.widthAnchor),
            
            nftRatingView.topAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: 8),
            nftRatingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftRatingView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            nftRatingView.bottomAnchor.constraint(equalTo: nftRatingView.topAnchor, constant: 12),
            
            nftNameAndPriceView.topAnchor.constraint(equalTo: nftRatingView.bottomAnchor, constant: 5),
            nftNameAndPriceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftNameAndPriceView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.63),
            nftNameAndPriceView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nftName.topAnchor.constraint(equalTo: nftNameAndPriceView.topAnchor),
            nftName.leadingAnchor.constraint(equalTo: nftNameAndPriceView.leadingAnchor),
            nftName.trailingAnchor.constraint(lessThanOrEqualTo: nftNameAndPriceView.trailingAnchor),
            
            nftPrice.bottomAnchor.constraint(equalTo: nftNameAndPriceView.bottomAnchor),
            nftPrice.leadingAnchor.constraint(equalTo: nftNameAndPriceView.leadingAnchor),
            nftPrice.trailingAnchor.constraint(lessThanOrEqualTo: nftNameAndPriceView.trailingAnchor),
            
            cartButton.centerYAnchor.constraint(equalTo: nftNameAndPriceView.centerYAnchor),
            cartButton.leadingAnchor.constraint(greaterThanOrEqualTo: nftNameAndPriceView.trailingAnchor),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func renderRatingView(view: UIStackView, value: Int) {
        for view in view.subviews {
            view.removeFromSuperview()
        }
        let val = value < 0 || value > 5 ? 0 : value
        let grayStarsCount = 5 - val
        if val > 0 {
            for _ in 1...val {
                view.addArrangedSubview(starView(filled: true))
            }
        }
        if grayStarsCount > 0 {
            for _ in 1...grayStarsCount {
                view.addArrangedSubview(starView(filled: false))
            }
        }
    }

    private func starView(filled: Bool) -> UIImageView {
        let star = UIImageView(image: UIImage(named: "star")?.withRenderingMode(.alwaysTemplate))
        star.tintColor = filled ? UIColor.starYellow : UIColor.starGray
        return star
    }
    
    func setup(cartTapHandle: (() -> Void)? = nil, likeTapHandle: @escaping (() -> Void)) {
        self.cartTapHandle = cartTapHandle
        self.likeTapHandle = likeTapHandle
    }
    
    @objc private func didTapCart() {
        cartTapHandle?()
    }
    
    @objc private func didTapLike() {
        likeTapHandle?()
    }
}
