import UIKit
import ProgressHUD

final class CatalogViewController: UIViewController {
    var viewModel: CatalogViewModelProtocol
    private let navBar = UINavigationBar()
    private let collectionsTableView = ContentSizedTableView()
    
    init(viewModel: CatalogViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupNavigationBar()
        setupUI()
        configureTable()
        setupConstraints()
        bind()
        viewModel.getNFTCollections()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getNFTCollections()
    }
    
    lazy private var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: .asset(.sort),
            style: .plain,
            target: self,
            action: #selector(showSortingMenu))
        button.tintColor = .asset(.black)
        return button
    }()
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupUI() {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = .asset(.black)

        collectionsTableView.backgroundColor = .asset(.white)
        view.backgroundColor = .asset(.white)
        view.addSubview(navBar)
        view.addSubview(collectionsTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            collectionsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            collectionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTable() {
        collectionsTableView.translatesAutoresizingMaskIntoConstraints = false
        collectionsTableView.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.reuseIdentifier)
        collectionsTableView.separatorInset = UIEdgeInsets.zero
        collectionsTableView.layoutMargins = UIEdgeInsets.zero
        collectionsTableView.dataSource = self
        collectionsTableView.delegate = self
    }
    
    func bind() {
        viewModel.onNFTCollectionsUpdate = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                self?.collectionsTableView.reloadData()
            }
        }
        
        viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.defaultShowLoading(self.viewModel.isLoading)
            }
        }
        
        viewModel.showAlertClosure = {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                let titleText = "Упс! У нас ошибка."
                let messageText = self.viewModel.errorMessage ?? "Unknown error"
                
                let alert = RepeatAlertMaker.make(
                    title: titleText,
                    message: messageText,
                    repeatHandle: { [weak self] in
                        self?.viewModel.getNFTCollections()
                        
                    }, cancelHandle: { [weak self] in
                        self?.viewModel.isLoading = false
                    }
                )
                
                self.present(alert, animated: true)
            }
        }
    }
    
    @objc private func showSortingMenu() {
        let sortMenu = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        sortMenu.addAction(UIAlertAction(title: "По названию", style: .default , handler:{ [weak self] (UIAlertAction) in
            self?.viewModel.sortNFTCollections(by: .name)
            }))
        sortMenu.addAction(UIAlertAction(title: "По количеству NFT", style: .default , handler:{ [weak self] (UIAlertAction) in
            self?.viewModel.sortNFTCollections(by: .nftCount)
            }))
        sortMenu.addAction(UIAlertAction(title: "Закрыть", style: .cancel))

        present(sortMenu, animated: true)
    }
    
    private func defaultShowLoading(_ isLoading: Bool) {
        if isLoading {
            ProgressHUD.show()
        } else {
            ProgressHUD.dismiss()
        }

        view.isUserInteractionEnabled = !isLoading
    }
}

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.NFTCollectionsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.reuseIdentifier, for: indexPath) as? CatalogCell,
              let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        else { return CatalogCell() }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        cell.viewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let collectionId = viewModel.getCellViewModel(at: indexPath)?.id else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = .asset(.white)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            
        let collectionViewModel = CollectionViewModel(
            model: CollectionModel(
                networkClient: viewModel.model.networkClient
            ),
            nftCollectionId: collectionId,
            converter: FakeConvertService()
        )
        
        let colectionViewController = CollectionViewController(viewModel: collectionViewModel)
        colectionViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(colectionViewController, animated: true)
    }
}
