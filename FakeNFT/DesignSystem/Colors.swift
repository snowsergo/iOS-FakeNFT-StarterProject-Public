import UIKit

enum ColorAsset: String {
    case black
    case blackUniversal
    case blue
    case green
    case gray
    case lightGray
    case red
    case white
    case whiteUniversal
    case yellow
}

extension UIColor {
    static func asset(_ colorAsset: ColorAsset) -> UIColor {
        UIColor(named: colorAsset.rawValue) ?? .clear
    }
}
