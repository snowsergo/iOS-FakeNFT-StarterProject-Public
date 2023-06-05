//
// Created by Сергей Махленко on 18.05.2023.
//

import UIKit

enum ButtonStyle {
    case standard
    case primary
    case secondary

    var backgroundColorPressed: UIColor? {
        .asset(.gray)
    }

    var textColorPressed: UIColor? {
        .asset(.lightGray)
    }

    var backgroundColor: UIColor? {
        switch self {
        case .standard:
            return .asset(.white)
        case .primary:
            return .asset(.black)
        case .secondary:
            return nil
        }
    }

    var textColor: UIColor {
        switch self {
        case .standard:
            return .asset(.black)
        case .primary:
            return .asset(.white)
        case .secondary:
            return .asset(.gray)
        }
    }

    var borderColor: UIColor? {
        switch self {
        case .secondary:
            return .asset(.gray)
        case .standard, .primary:
            return nil
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .secondary:
            return 1
        case .standard, .primary:
            return 0
        }
    }

    var fontStyle: UIFont {
        switch self {
        case .secondary:
            return .caption1
        case .standard, .primary:
            return .bodyBold
        }
    }
}
