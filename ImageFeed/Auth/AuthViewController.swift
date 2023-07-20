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
final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private lazy var authView = {
        let view = AuthView()
        view.signInButton.addTarget(
            nil,
            action: #selector(didTapSignInButton),
            for: .touchUpInside
        )
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = authView
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
