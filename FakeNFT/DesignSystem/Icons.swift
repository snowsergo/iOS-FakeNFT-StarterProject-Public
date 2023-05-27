//
// Created by Сергей Махленко on 27.05.2023.
//

import UIKit

enum Icons: String {
    case trash = "trash-icon"
    case successPay = "success-pay-status"
    case failurePay = "failure-pay-status"
    case filter = "filter-icon"
}

extension UIImage {
    static func asset(_ icon: Icons) -> UIImage {
        guard let image = UIImage(named: icon.rawValue) else {
            preconditionFailure("Icon \"\(icon.rawValue)\" not found.")
        }

        return image
    }
}
