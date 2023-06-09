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
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
    
    static let NFTBlack = UIColor(named: "NFTBlack") ?? UIColor.black
    static let NFTAlwaysBlack = UIColor(named: "NFTAlwaysBlack") ?? UIColor.black
    static let NFTWhite = UIColor(named: "NFTWhite") ?? UIColor.white
    static let NFTLinkBlue = UIColor(named: "NFTLinkBlue") ?? UIColor.blue
    static let NFTGreen = UIColor(named: "NFTGreen") ?? UIColor.green
    static let starYellow = UIColor(named: "starYellow") ?? UIColor.yellow
    static let starGray = UIColor(named: "starGray") ?? UIColor.gray
    static let NFTLike = UIColor(named: "NFTLike") ?? UIColor.systemPink
}
