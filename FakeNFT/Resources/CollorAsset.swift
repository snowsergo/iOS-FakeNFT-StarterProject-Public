import UIKit

enum ColorAsset: String, CaseIterable {
    case black
    case blue
    case white
    case lightGrey
    case yellow
}

extension UIColor {
    static func asset(_ colorAsset: ColorAsset) -> UIColor {
        UIColor(named: colorAsset.rawValue) ?? .clear
    }
}
