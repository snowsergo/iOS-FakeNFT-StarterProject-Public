//
// Created by Сергей Махленко on 03.06.2023.
//

import Foundation

enum Padding: Float {
    case minStep = 2
    case standard = 16
    case standardInverse = -16
    case large = 20
    case cellSpacing = 7
}

extension CGFloat {
    static func padding(_ size: Padding) -> CGFloat {
        CGFloat(size.rawValue)
    }
}
