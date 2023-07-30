//
//  AuthViewController.swift
//  ImageFeed
//

import UIKit

// MARK: - AuthViewControllerDelegate
protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

// MARK: - AuthViewController
final class AuthViewController: LightContentViewController {
    weak var delegate: AuthViewControllerDelegate?

    override func loadView() {
        view = AuthView {
            self.didTapSignInButton()
        }
    }

    @objc private func didTapSignInButton() {
        let webViewViewController = WebViewViewController()
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        webViewViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewViewController
        webViewViewController.delegate = self

        webViewViewController.modalPresentationStyle = .fullScreen
        webViewViewController.modalTransitionStyle = .crossDissolve

        navigationController?.pushViewController(webViewViewController, animated: true)
    }
}

// MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        navigationController?.popViewController(animated: true)
    }
}
