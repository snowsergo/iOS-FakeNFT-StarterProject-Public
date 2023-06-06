//
// Created by Сергей Махленко on 27.05.2023.
//

import UIKit

enum Icons: String {
    case trash = "trash-icon"
    case successPay = "success-pay-status"
    case failurePay = "failure-pay-status"
    case sort = "sort-icon"
}

extension UIImage {
    static func asset(_ icon: Icons) -> UIImage {
        UIImage(named: icon.rawValue) ?? UIImage()
    }
}
