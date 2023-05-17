//
// Created by Сергей Махленко on 18.05.2023.
//

import UIKit

/**
 General screen controller for Cart Screen
 */
class CartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.subviews.forEach({ $0.removeFromSuperview() })
    }
}
