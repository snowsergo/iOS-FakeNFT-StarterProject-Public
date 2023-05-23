//
// Created by Сергей Махленко on 23.05.2023.
//

import UIKit

struct ColorScheme {
    // MARK: - Depend on the user scheme

    static var black: UIColor {
        UIColor { (traits: UITraitCollection) -> UIColor in
            traits.userInterfaceStyle == .light
                    ? UIColor(hexString: "#1A1B22")
                    : UIColor(hexString: "#FFFFFF")
        }
    }

    static var white: UIColor {
        UIColor { (traits: UITraitCollection) -> UIColor in
            traits.userInterfaceStyle == .light
                    ? UIColor(hexString: "#FFFFFF")
                    : UIColor(hexString: "#1A1B22")
        }
    }

    static var lightGrey: UIColor {
        UIColor { (traits: UITraitCollection) -> UIColor in
            traits.userInterfaceStyle == .light
                    ? UIColor(hexString: "#F7F7F8")
                    : UIColor(hexString: "#2C2C2E")
        }
    }

    // MARK: - Universal colors

    static var red: UIColor { UIColor.init(hexString: "#F56B6C") }
    static var background: UIColor { UIColor.init(hexString: "#8d8d9180") }
    static var green: UIColor { UIColor.init(hexString: "#1C9F00") }
    static var grey: UIColor { UIColor.init(hexString: "#625C5C") }
    static var blue: UIColor { UIColor.init(hexString: "#0A84FF") }
    static var yellow: UIColor { UIColor.init(hexString: "#FEEF0D") }
    static var blackUniversal: UIColor { UIColor.init(hexString: "#1A1B22") }
    static var whiteUniversal: UIColor { UIColor.init(hexString: "#FFFFFF") }
}
