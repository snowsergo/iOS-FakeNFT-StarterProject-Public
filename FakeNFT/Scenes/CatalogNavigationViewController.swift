import UIKit

final class CatalogNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .asset(.white)
        navigationBar.tintColor = .asset(.black)
        pushViewController(CatalogViewController(viewModel: CatalogViewModel(model: CatalogModel(networkClient: DefaultNetworkClient()))), animated: false)
    }
}
