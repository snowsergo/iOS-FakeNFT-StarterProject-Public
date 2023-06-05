import UIKit

class StatisticsNavigationController: UINavigationController {
    // TODO: Думаю его нужно поднимать выше в SceneDelegate для всего приложения
    static var sharedNetworkClient = DefaultNetworkClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .asset(.white)
        navigationBar.tintColor = .asset(.black)
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        let rootController = StatisticsPageViewController()
        pushViewController(rootController, animated: false)
    }
}
