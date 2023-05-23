//
// Created by Сергей Махленко on 18.05.2023.
//

import UIKit

enum ButtonStyle {
    case standard
    case primary
    case secondary

    var backgroundColorPressed: UIColor? {
        ColorScheme.grey
    }

    var textColorPressed: UIColor? {
        ColorScheme.lightGrey
    }

    var backgroundColor: UIColor? {
        switch self {
        case .standard:
            return ColorScheme.white
        case .primary:
            return ColorScheme.black
        default:
            return nil
        }
    }

    var textColor: UIColor {
        switch self {
        case .standard:
            return ColorScheme.black
        case .primary:
            return ColorScheme.white
        case .secondary:
            return ColorScheme.grey
        }
    }

    var borderColor: UIColor? {
        switch self {
        case .secondary:
            return ColorScheme.grey
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
