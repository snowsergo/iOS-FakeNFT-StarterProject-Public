import UIKit
import ProgressHUD

final class StatisticsUserCollectionPageViewController: UIViewController {
    private var viewModel: StatisticsUserCollectionPageViewModel!
    private var nfts: [Int]?

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(StatisticsNftCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let model = StatisticsUserCollectionModel()
        viewModel = StatisticsUserCollectionPageViewModel(model: model)
        viewModel.onChange = change
        viewModel.getUserNfts(ids: nfts ?? [], showLoader: showLoader)
        view.backgroundColor = .asset(.white)
        setupCollectionView()
    }

    init(nfts: [Int]?) {
        self.nfts = nfts
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func change() {
        collectionView.reloadData()
    }

    // настройка коллекции
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .asset(.white)

        view.addSubview(collectionView)
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func showLoader(isShow: Bool) {
        DispatchQueue.main.async {
            if isShow {
                self.view.isUserInteractionEnabled = false
                ProgressHUD.show()
            } else {
                self.view.isUserInteractionEnabled = true
                ProgressHUD.dismiss()
            }
        }
    }
}

extension StatisticsUserCollectionPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.nfts.count
    }

    // ячейка nft
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? StatisticsNftCell else {
            fatalError("Unable to dequeue StatisticsNftCell")
        }

        let nft = viewModel.nfts[indexPath.row]
        cell.configure(with: nft)
        return cell
    }

}

extension StatisticsUserCollectionPageViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 16 - 16 - 16) / 3, height: 192)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 16, bottom: 16, right: 16)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 20
    }
}
