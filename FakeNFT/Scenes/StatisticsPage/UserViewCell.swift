import UIKit
import Kingfisher

final class UserViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(index: String? = nil, label: String? = nil, count: String? = nil, url: String? = nil) {
        indexView.text = index
        labelView.text = label
        countView.text = count

        guard let url = url, let validUrl = URL(string: url) else {return}
        let imageSize = CGSize(width: 28, height: 28)
        let placeholderSize = CGSize(width: 28, height: 28)
        let processor = RoundCornerImageProcessor(cornerRadius: imageSize.width / 2)
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ]
        avatarView.kf.setImage(with: validUrl, placeholder: UIImage(named: "avatar")?.kf.resize(to: placeholderSize), options: options)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configure()
    }

    private lazy var labelView: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.black)
        label.font = .headline3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var countView: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.black)
        label.font = .headline3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var indexView: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.black)
        label.font = .caption1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .asset(.lightGrey)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false

        // Задаем размер изображения
        let imageSize = CGSize(width: 28, height: 28)
        view.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true

        // Задаем форму в виде круга
        view.layer.cornerRadius = imageSize.width / 2
        view.clipsToBounds = true

        return view
    }()
}

// MARK: - Appearance
private extension UserViewCell {

    func setupAppearance() {
        backgroundColor = .clear
        selectionStyle = .none

        addSubview(indexView)
        addSubview(labelView)
        addSubview(countView)
        addSubview(avatarView)
        insertSubview(backView, at: 0)

        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),

            indexView.centerYAnchor.constraint(equalTo: centerYAnchor),
            indexView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            indexView.topAnchor.constraint(equalTo: topAnchor, constant: 26.5),
            indexView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26.5),

            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),

            labelView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            labelView.topAnchor.constraint(equalTo: topAnchor, constant: 26.5),
            labelView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26.5),

            countView.centerYAnchor.constraint(equalTo: centerYAnchor),
            countView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
            countView.topAnchor.constraint(equalTo: topAnchor, constant: 26.5),
            countView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26.5)
        ])
    }
}
