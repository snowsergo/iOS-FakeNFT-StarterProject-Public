import UIKit

final class ProductCartTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ProductCartTableViewCell.self)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        30
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductCartTableViewCell = tableView.dequeueReusableCell()

        cell.textLabel?.text = "Ячейка номер \(indexPath.row)"

        return cell
    }
}
