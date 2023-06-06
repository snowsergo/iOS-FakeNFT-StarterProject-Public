//
// Created by Сергей Махленко on 18.05.2023.
//

import UIKit

enum ButtonSize {
    case normal
    case large

    var edgeInsets: UIEdgeInsets {
        switch self {
        case .normal:
            return UIEdgeInsets(top: 11, left: 22, bottom: 11, right: 22)
        case .large:
            return UIEdgeInsets(top: 19, left: 31, bottom: 19, right: 31)
        }
    }
}
