//
// Created by Сергей Махленко on 02.06.2023.
//

import UIKit

class PaymentViewController: UIViewController {

    private var viewModel: PaymentViewModel = {
        PaymentViewModel()
    }()

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
             userAgreementTextView.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: .padding(.large)),
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
    }
}

// MARK: - Extensions

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
}

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PaymentTypeViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        return cell;
    }
}
