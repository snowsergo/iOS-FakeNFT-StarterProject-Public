import UIKit

final class OrderDetailsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorScheme.white
        tableView.register(OrderDetailsTableViewCell.self)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        30
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OrderDetailsTableViewCell = tableView.dequeueReusableCell()

        cell.backgroundColor = ColorScheme.white
        cell.textLabel?.text = "Ячейка номер \(indexPath.row)"

        return cell
    }
}
