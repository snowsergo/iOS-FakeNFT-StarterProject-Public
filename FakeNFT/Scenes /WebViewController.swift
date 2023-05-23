//
// Created by Сергей Махленко on 22.05.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    // MARK: - Variables

    private var urlRequest: URLRequest

    private var webViewObserve: NSKeyValueObservation?

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorScheme.white
        return webView
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = ColorScheme.blue
        progressView.trackTintColor = ColorScheme.lightGrey
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

        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        webView.load(urlRequest)

        webViewObserve = webView.observe(\WKWebView.estimatedProgress, options: .new) { [self] (_: WKWebView, change:NSKeyValueObservedChange<Double>) in
            progressView.setProgress(Float(change.newValue!), animated: true)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        guard let webViewObserve = webViewObserve else { return }
        NotificationCenter.default.removeObserver(webViewObserve)
    }

    // MARK: - Private methods

    private func setup() {
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

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Fail: \(error.localizedDescription)")
    }
}
