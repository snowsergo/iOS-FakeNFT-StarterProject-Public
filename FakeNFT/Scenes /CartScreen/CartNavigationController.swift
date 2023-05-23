//
// Created by Сергей Махленко on 23.05.2023.
//

import UIKit

class CartNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        navigationBar.tintColor = .primary
        navigationBar.overrideUserInterfaceStyle = .light

        let rootController = CartViewController()
        pushViewController(rootController, animated: false)
    }
}
