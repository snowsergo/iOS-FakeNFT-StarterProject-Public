import UIKit

final class OrderDetailsTableViewController: UITableViewController {

    var delegate: OrderTableCellDelegate?

    var items: [Nft] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorScheme.white
        tableView.register(OrderDetailsTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderDetailsTableViewCell = tableView.dequeueReusableCell()

        let model = items[indexPath.row]

        cell.setModel(model, itemIndex: indexPath.row)
        cell.delegate = delegate

        return cell
    }
}
