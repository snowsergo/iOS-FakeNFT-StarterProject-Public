// Colors for profile epic

import UIKit

extension UIColor {

    // Background Colors
    static let background = UIColor.white
    static let viewBackgroundColor = UIColor.systemBackground
    static var lightGreyBackground: UIColor { UIColor(named: "LightGreyBackground") ?? .systemGray5 }

    // Text Colors
    static let textPrimary = UIColor.black
    static let textSecondary = UIColor.gray
    static let textOnPrimary = UIColor.white
    static let textOnSecondary = UIColor.black

    // Font colors
    static var textColorBlack: UIColor { UIColor(named: "TextColorBlack") ?? .black }
    static var textColorBlue: UIColor { UIColor(named: "TextColorBlue") ?? .systemBlue }

    // Rating star colors
    static var ratingStarYellow: UIColor { UIColor(named: "RatingStarYellow") ?? .systemYellow }
    static var ratingStarLightGray: UIColor { UIColor(named: "RatingStarLightGray") ?? .systemGray6 }

    // Like button color
    static var redHeartColor: UIColor { UIColor(named: "RedHeartColor") ?? .systemRed }
}
