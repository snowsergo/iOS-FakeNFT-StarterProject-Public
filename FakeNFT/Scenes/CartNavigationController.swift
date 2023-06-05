//
// Created by Сергей Махленко on 23.05.2023.
//

import UIKit

class CartNavigationController: UINavigationController {
    // TODO: Думаю его нужно поднимать выше в SceneDelegate для всего приложения
    static var sharedNetworkClient = DefaultNetworkClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .asset(.white)
        navigationBar.tintColor = .asset(.black)

        let rootController = CartViewController()
        pushViewController(rootController, animated: false)
    }
}
