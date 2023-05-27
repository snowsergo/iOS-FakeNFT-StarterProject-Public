//
// Created by Сергей Махленко on 23.05.2023.
//

import UIKit

class CartNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .asset(.white)
        navigationBar.tintColor = .asset(.black)

        let rootController = CartViewController()
        pushViewController(rootController, animated: false)
    }
}
