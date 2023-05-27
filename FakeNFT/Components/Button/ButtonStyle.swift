//
// Created by Сергей Махленко on 18.05.2023.
//

import UIKit

enum ButtonStyle {
    case standard
    case primary
    case secondary

    var backgroundColorPressed: UIColor? {
        .asset(.grey)
    }

    var textColorPressed: UIColor? {
        .asset(.lightGrey)
    }

    var backgroundColor: UIColor? {
        switch self {
        case .standard:
            return .asset(.white)
        case .primary:
            return .asset(.black)
        default:
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
            return .asset(.grey)
        }
    }

    var borderColor: UIColor? {
        switch self {
        case .secondary:
            return .asset(.grey)
        default:
            return nil
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .secondary:
            return 1
        default:
            return 0
        }
    }

    var fontStyle: UIFont {
        switch self {
        case .secondary:
            return .caption1
        default:
            return .bodyBold
        }
    }
}
