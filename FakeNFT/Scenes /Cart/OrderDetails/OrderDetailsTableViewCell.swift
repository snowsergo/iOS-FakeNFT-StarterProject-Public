import UIKit

final class OrderDetailsTableViewCell: UITableViewCell, ReuseIdentifying {
    var pictureView: UIImageView = {
        let pictureView = UIImageView()
        pictureView.translatesAutoresizingMaskIntoConstraints = false

//        pictureView.backgroundColor = .systemGray4
        pictureView.clipsToBounds = true
        pictureView.layer.cornerRadius = 12

        return pictureView
    }()

    var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()

    var starIconImage: UIButton = {
        UIButton()
    }()

    var priceLabel: UILabel = {
        UILabel()
    }()

    var cost: UILabel = {
        UILabel()
    }()

    var deleteButton: UIButton = {
        UIButton()
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
