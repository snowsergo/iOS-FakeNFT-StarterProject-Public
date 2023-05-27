//
// Created by Сергей Махленко on 27.05.2023.
//

import UIKit

final class CurrencyCollectionViewController: UICollectionViewController {
    private let spacing = 7.0

    private let perRow = 2.0

    var delegate: CurrencyUpdateCollectionDelegate?

    var items: [CurrencyNetworkModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        collectionView.register(CurrencyCollectionViewCell.self)
        collectionView.backgroundColor = .asset(.white)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = false
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate as? PayStatusDelegate else { return }
        delegate.didSelected(at: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CurrencyCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)

        let item = items[indexPath.row]
        cell.setModel(model: item)

        return cell
    }
}

extension CurrencyCollectionViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacingWidth = spacing * (perRow - 1)
        return CGSize(width: (collectionView.bounds.width - totalSpacingWidth) / perRow, height: 46)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spacing
    }
}
