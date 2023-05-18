import UIKit

extension UIColor {
    // Creates color from a hex string
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

    // Creates color from BrandColor
    convenience init(color: BrandColors) {
        self.init(hexString: color.rawValue)
    }

    // MARK: - Colors

    static let primary = UIColor(color: .dark)
    static let secondary = UIColor(color: .secondaryGray)
    static let background = UIColor(color: .white)
    static let textPrimary = UIColor(color: .dark)
    static let textSecondary = UIColor(color: .secondaryGray)
    static let textOnPrimary = UIColor(color: .lightGray)
    static let textOnSecondary = UIColor(color: .lightGray)
    static let success = UIColor(color: .green)
    static let failure = UIColor(color: .red)
}
