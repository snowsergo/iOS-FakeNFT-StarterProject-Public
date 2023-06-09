import UIKit

final class CatalogNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        pushViewController(CatalogViewController(viewModel: CatalogViewModel(model: CatalogModel(networkClient: DefaultNetworkClient()))), animated: false)
    }
}
