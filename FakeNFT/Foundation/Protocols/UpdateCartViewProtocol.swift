//
// Created by Сергей Махленко on 25.05.2023.
//

import UIKit

protocol UpdateCartViewProtocol {
    func fetchData(refreshControl: UIRefreshControl?)
    func didUpdateTotalInfo()
    func showConfirmDelete(itemId: String)
    func deleteItem(itemId: String)
}
