//
// Created by Сергей Махленко on 22.05.2023.
//

import UIKit
import WebKit
import ProgressHUD

final class WebViewController: UIViewController {
    // MARK: - Variables

    private let timeoutInterval = 5

    private var urlRequest: URLRequest

    private var webViewObserve: NSKeyValueObservation?

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .asset(.white)
        return webView
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .asset(.blue)
        progressView.trackTintColor = .asset(.lightGrey)
        progressView.setProgress(0.0, animated: false)
        return progressView
    }()

    // MARK: - Conversion initializes

    init(request: URLRequest) {
        urlRequest = request
        super.init(nibName: nil, bundle: nil)
    }

    init(url: String) {
        guard let url = URL(string: url) else {
            fatalError("URL failed")
        }

        urlRequest = URLRequest(url: url)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Usage view methods

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        webView.addSubview(progressView)
        view.addSubview(webView)

        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        webViewObserve = webView.observe(\WKWebView.estimatedProgress, options: .new) { [self] (_: WKWebView, change:NSKeyValueObservedChange<Double>) in
            progressView.setProgress(Float(change.newValue!), animated: false)
            if change.newValue! > 0 {
                ProgressHUD.dismiss()
            }
        }

        didLoadPage()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        guard let webViewObserve = webViewObserve else { return }
        NotificationCenter.default.removeObserver(webViewObserve)
    }

    // MARK: - Private methods

    private func didLoadPage() {
        urlRequest.timeoutInterval = TimeInterval(timeoutInterval)
        webView.load(urlRequest)
        ProgressHUD.show()
    }

    private func setupView() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
        ])
    }
}

// MARK: - Extensions

extension WebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        progressView.isHidden = false
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        title = webView.title
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let errorView = ErrorView.make(
            title: "Упс! Что-то пошло не так",
            message: error.localizedDescription,
            repeatHandle: { [weak self] in
                guard let self else { return }
                didLoadPage()
            },
            cancelHandle: { [weak self] in
                guard let self else { return }
                navigationController?.popViewController(animated: true)
                ProgressHUD.dismiss()
            })

        present(errorView, animated: true)
    }
}
