import UIKit

final class OrderDetailsTableViewController: UITableViewController {

    var delegate: UpdateCartViewProtocol?

    var items: [Nft] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .asset(.white)
        tableView.register(OrderDetailsTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
    }

    @objc func didRefresh() {
        delegate?.fetchData(refreshControl: refreshControl)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderDetailsTableViewCell = tableView.dequeueReusableCell()

        let model = items[indexPath.row]

        cell.setModel(model)
        cell.delegate = delegate

        return cell
    }
}
