//
//  WebViewViewController.swift
//  ImageFeed
//

import WebKit
import UIKit

// MARK: - WebViewViewControllerProtocol
protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

// MARK: - WebViewViewControllerDelegate
protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

// MARK: - WebViewViewController
final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    private var estimatedProgressObservation: NSKeyValueObservation?

    weak var delegate: WebViewViewControllerDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    private lazy var webViewView = {
        let view = WebViewView()
        view.backButton.addTarget(
            nil,
            action: #selector(didTapBackButton),
            for: .touchUpInside
        )
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view = webViewView

        webViewView.webView.navigationDelegate = self
        presenter?.viewDidLoad()
        estimatedProgressObservation = webViewView.webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 self.presenter?.didUpdateProgressValue(self.webViewView.webView.estimatedProgress)
             }
        )
    }

    func load(request: URLRequest) {
        webViewView.webView.load(request)
    }

    func setProgressValue(_ newValue: Float) {
        webViewView.progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        webViewView.progressView.isHidden = isHidden
    }

    @objc private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        } else {
            return nil
        }
    }
}

// MARK: Clean WK data
extension WebViewViewController {
    static func cleanWKData() {
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
       }
    }
}
