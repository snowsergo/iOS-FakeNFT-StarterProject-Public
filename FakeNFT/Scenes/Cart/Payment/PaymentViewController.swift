//
// Created by Сергей Махленко on 02.06.2023.
//

import UIKit
import ProgressHUD

class PaymentViewController: UIViewController {
    private var viewModel: PaymentViewModel = {
        PaymentViewModel(networkClient: CartNavigationController.sharedNetworkClient)
    }()

    init(order: Order) {
        viewModel.order = order
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK - UI Elements

    lazy private var paymentMethodsCollection: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.backgroundColor = .asset(.white)
        collection.register(PaymentTypeViewCell.self)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()

    lazy private var payButton: UIButton = {
        let button = ButtonComponent(.primary, size: .large)
        button.setTitle("Оплатить", for: .normal)
        button.addTarget(self, action: #selector(didTapPay), for: .touchUpInside)
        return button
    }()

    lazy private var userAgreementTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.backgroundColor = .asset(.white)
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let text = "Совершая покупку, вы соглашаетесь с условиями"
        let link = "Пользовательского соглашения"
        let attributedString = NSMutableAttributedString(string: "\(text) \(link)")

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.lineBreakMode = .byWordWrapping

        attributedString.addAttributes([
            .font: UIFont.caption2,
            .foregroundColor: UIColor.asset(.black),
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: attributedString.length))

        attributedString.addAttribute(.link,
            value: Config.userAgreementUrl,
            range: NSRange(location: text.count + 1, length: link.count))

        textView.attributedText = attributedString

        return textView
    }()

    // MARK: - Setup view

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupViewModel()
    }
    
    private func setupView() {
        title = "Выберите способ оплаты"
        view.backgroundColor = .asset(.white)

        view.addSubview(userAgreementTextView)
        view.addSubview(paymentMethodsCollection)
        view.addSubview(payButton)
    }

    private func setupLayout() {
        let safeArea = view.safeAreaLayoutGuide

        [paymentMethodsCollection, userAgreementTextView, payButton]
            .forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })

        NSLayoutConstraint.activate([
            paymentMethodsCollection.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: .padding(.standard)),
            paymentMethodsCollection.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: .padding(.standardInverse)),
            paymentMethodsCollection.bottomAnchor.constraint(equalTo: userAgreementTextView.topAnchor, constant: .padding(.standardInverse)),
            paymentMethodsCollection.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .padding(.standard))
        ])

        NSLayoutConstraint.activate([
             userAgreementTextView.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: .padding(.largeInverse)),
             userAgreementTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: .padding(.standardInverse)),
             userAgreementTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .padding(.standard)),
        ])

        NSLayoutConstraint.activate([
            payButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            payButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: .padding(.standardInverse)),
            payButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .padding(.standard)),
        ])
    }

    func setupViewModel() {
        viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                let isLoading = self?.viewModel.isLoading ?? false

                isLoading ? ProgressHUD.show() : ProgressHUD.dismiss()
                self?.view.isUserInteractionEnabled = !isLoading
            }
        }

        viewModel.showAlertClosure = {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                let alert = RepeatAlertMaker.make(
                        title: "Упс! У нас ошибка.",
                        message: self.viewModel.errorMessage!) { [weak self] in
                    self?.viewModel.fetchPaymentMethods()
                }

                present(alert, animated: true)
            }
        }

        viewModel.reloadCollectionViewClosure = {
            DispatchQueue.main.async { [weak self] in
                self?.paymentMethodsCollection.reloadData()
            }
        }

        viewModel.methodNotSelectedClosure = {
            DispatchQueue.main.async { [weak self] in
                let alertController = UIAlertController(
                        title: "Так не пойдет 🤨",
                        message: "Выберите метод оплаты",
                        preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "Понятно", style: .cancel))

                self?.present(alertController, animated: true)
            }
        }

        viewModel.checkedPayStatusClosure = { paymentStatus in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                let viewController = paymentStatus.success
                    ? PaySuccessfulViewController()
                    : PayFailureViewController()

                viewController.modalPresentationStyle = .fullScreen
                navigationController?.present(viewController, animated: true)
            }
        }

        viewModel.fetchPaymentMethods()
    }
}

// MARK: - Extensions

extension PaymentViewController {
    @objc private func didTapPay() {
        viewModel.checkPayment()
    }
}

extension PaymentViewController: UITextViewDelegate {
    func textView(
            _ textView: UITextView,
            shouldInteractWith URL: URL,
            in characterRange: NSRange,
            interaction: UITextItemInteraction) -> Bool {

        let webView = WebViewService(url: URL)
        if let navigationController = navigationController {
            navigationController.pushViewController(webView, animated: true)
            return false
        }

        // fallback
        return true
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let perRow = 2.0
        let totalSpacingWidth = .padding(.cellSpacing) * (perRow - 1)
        return CGSize(width: (collectionView.bounds.width - totalSpacingWidth) / perRow, height: 46)
    }

    public func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        .padding(.cellSpacing)
    }

    public func collectionView(
            _ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        .padding(.cellSpacing)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedPaymentMethodId = viewModel.getCellViewModel(at: indexPath).id
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.selectedPaymentMethodId = nil
    }
}

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PaymentTypeViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let model = viewModel.getCellViewModel(at: indexPath)

        cell.setup(model: model)

        return cell;
    }
}
