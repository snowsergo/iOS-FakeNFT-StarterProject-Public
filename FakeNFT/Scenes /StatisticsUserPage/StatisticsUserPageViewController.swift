import UIKit
import Kingfisher
import WebKit

final class StatisticsUserPageViewController: UIViewController {
    private var viewModel: StatisticsUserPageViewModel!
    private let labelView: UILabel = UILabel()
    private let submitButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
    private let userId: String

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = StatisticsUserPageViewModel()
        viewModel.onChange = configure
        viewModel.getUser(userId: userId)
        setupAppearance()
        view.backgroundColor = .white
    }

    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var nameView: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false

        // Задаем размер изображения
        let imageSize = CGSize(width: 70, height: 70)
        view.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true

        // Задаем форму в виде круга
        view.layer.cornerRadius = imageSize.width / 2
        view.clipsToBounds = true

        return view
    }()

    private lazy var descriptionView: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .asset(.black)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var siteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)

        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        button.tintColor = .clear
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var collectionButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "Коллекция NFT"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var collectionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center

        let iconImageView = UIImageView(image: UIImage(named: "rightArrow"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        stackView.addArrangedSubview(collectionButtonLabel)
        stackView.addArrangedSubview(iconImageView)

        button.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: button.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openNFTCollection))
        stackView.addGestureRecognizer(tapGesture)
        stackView.isUserInteractionEnabled = true

        return button
    }()

    func configure() {
        guard let user = viewModel.user else {return}
        guard  let validUrl = URL(string: user.avatar) else {return}
        let imageSize = CGSize(width: 70, height: 70)
        let placeholderSize = CGSize(width: 70, height: 70)
        let processor = RoundCornerImageProcessor(cornerRadius: imageSize.width / 2)
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ]
        avatarView.kf.setImage(with: validUrl, placeholder: UIImage(named: "avatar")?.kf.resize(to: placeholderSize), options: options)
        nameView.text = user.name
        descriptionView.text = user.description
        collectionButtonLabel.text = "Коллекция NFT (\(user.nfts.count))"
    }

    @objc
    private func openWebView() {
        guard let siteUrl = viewModel.user?.website, let url = URL(string: siteUrl) else {
            return
        }

        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        let viewController = UIViewController()
        viewController.view = webView

        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func openNFTCollection() {
        let viewController = StatisticsUserCollectionPageViewController(nfts: viewModel.user?.nfts)
        viewController.title = "Коллекция NFT"
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationController?.pushViewController(viewController, animated: true)
    }

    func setupAppearance() {
        view.backgroundColor = .white

        view.addSubview(avatarView)
        view.addSubview(nameView)
        view.addSubview(descriptionView)
        view.addSubview(siteButton)
        view.addSubview(collectionButton)

        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            nameView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            nameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),

            descriptionView.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            siteButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 30),
            siteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            siteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            siteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            siteButton.heightAnchor.constraint(equalToConstant: 40),

            collectionButton.topAnchor.constraint(equalTo: siteButton.bottomAnchor, constant: 56),
            collectionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
