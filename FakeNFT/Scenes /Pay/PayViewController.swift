//
// Created by Сергей Махленко on 21.05.2023.
//

import UIKit
import ProgressHUD

protocol PayStatusDelegate {
    func didSuccessful()
    func didSelected(at: IndexPath)
}

protocol CurrencyUpdateCollectionDelegate {
    func fetchData()
}

final class PayViewController: UIViewController {
    private let orderId: String

    private var selectedIndex: Int? {
        didSet {
            payButton.isEnabled = selectedIndex != nil
        }
    }

    private var items: [CurrencyNetworkModel] = [] {
        didSet {
            currencyCollectionController.items = items
        }
    }

    lazy private var currencyCollectionController: CurrencyCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        let controller = CurrencyCollectionViewController(collectionViewLayout: layout)
        controller.delegate = self

        return controller
    }()

    private let footerTextLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.text = "Совершая покупку, вы соглашаетесь с условиями"
        textLabel.font = .caption2

        return textLabel
    }()

    private let userAgreementLabel: UILabel = {
        let linkLabel = UILabel()
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.isUserInteractionEnabled = true
        linkLabel.text = "Пользовательского соглашения"
        linkLabel.textColor = .asset(.blue)
        linkLabel.font = .caption2

        return linkLabel
    }()

    private let payButton: UIButton = {
        let buttonView = ButtonComponent(.primary, size: .large)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.setTitle("Оплатить", for: .normal)
        buttonView.isEnabled = false

        return buttonView
    }()

    private let footerView: UIView = {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false

        return footerView
    }()

    init(orderId: String) {
        self.orderId = orderId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        title = "Выберите способ оплаты"

        footerView.addSubview(footerTextLabel)
        footerView.addSubview(userAgreementLabel)
        footerView.addSubview(payButton)
        view.addSubview(footerView)
        view.addSubview(currencyCollectionController.collectionView)

        view.backgroundColor = .asset(.white)
        navigationItem.backButtonTitle = ""

        setupView()

        fetchData()
    }

    // MARK: - Private methods

    private func setupView() {
        // Targets
        payButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)

        let didTapAgreement = UITapGestureRecognizer(target: self, action: #selector(didTapAgreement))
        userAgreementLabel.addGestureRecognizer(didTapAgreement)

        NSLayoutConstraint.activate([
            footerTextLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20),
            footerTextLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            footerTextLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),

            userAgreementLabel.topAnchor.constraint(equalTo: footerTextLabel.bottomAnchor, constant: 4),
            userAgreementLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            userAgreementLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),

            payButton.topAnchor.constraint(equalTo: userAgreementLabel.topAnchor, constant: 36),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),

            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            currencyCollectionController.collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currencyCollectionController.collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            currencyCollectionController.collectionView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            currencyCollectionController.collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        ])
    }

    @objc private func didTapPayButton() {
        guard let selectedIndex = selectedIndex else { return }
        let model = items[selectedIndex]

        UISelectionFeedbackGenerator().selectionChanged()
        let payStatusController = PayStatusViewController(orderId: orderId, currencyId: model.id)
        payStatusController.modalPresentationStyle = .fullScreen
        payStatusController.delegate = self

        present(payStatusController, animated: true)
    }

    @objc private func didTapAgreement(sender: UITapGestureRecognizer) {
        let vc = WebViewController(url: "https://yandex.ru/legal/practicum_termsofuse")
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PayViewController: CurrencyUpdateCollectionDelegate {
    func fetchData() {
        showLoader(isShow: true)
        CurrencyNetworkModel.fetchData { [weak self] result in
            guard let self else { return }
            showLoader(isShow: false)

            switch result {
            case .success(let models):
                self.items = models
            case .failure(let error):
                print(error)
            }
        }
    }

    func showLoader(isShow: Bool, refreshControl: UIRefreshControl? = nil) {
        if let refreshControl = refreshControl {
            isShow
                ? refreshControl.beginRefreshing()
                : refreshControl.endRefreshing()
            return
        }

        if isShow {
            view.isUserInteractionEnabled = false
            ProgressHUD.show()
        } else {
            view.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
        }
    }
}

extension PayViewController: PayStatusDelegate {
    func didSelected(at indexPath: IndexPath) {
        selectedIndex = indexPath.row
    }

    func didSuccessful() {
        navigationController?.popToRootViewController(animated: false)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.rootTabBarController.selectedIndex = 1
    }
}
