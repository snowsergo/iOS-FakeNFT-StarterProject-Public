//
// Created by Сергей Махленко on 18.05.2023.
//

import UIKit

enum ButtonStyle {
    case defaultStyle
    case primary
    case secondary

    var backgroundColorPressed: UIColor? {
        UIColor.secondary
    }

    var textColorPressed: UIColor? {
        UIColor.textOnSecondary
    }

    var backgroundColor: UIColor? {
        switch self {
        case .defaultStyle:
            return UIColor.textOnPrimary
        case .primary:
            return UIColor.primary
        default:
            return nil
        }
    }

    var textColor: UIColor {
        switch self {
        case .defaultStyle:
            return UIColor.primary
        case .primary:
            return UIColor.textOnPrimary
        case .secondary:
            return UIColor.primary
        }
    }

    var borderColor: UIColor? {
        switch self {
        case .secondary:
            return UIColor.secondary
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
            return .systemFont(ofSize: 15)
        default:
            return .boldSystemFont(ofSize: 17)
        }
    }
}
