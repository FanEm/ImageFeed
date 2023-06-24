//
//  SplashViewController.swift
//  ImageFeed
//

import Foundation
import UIKit

// MARK: - SplashViewController
final class SplashViewController: UIViewController {
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let oauth2Service = OAuth2Service.shared
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared

    private var mainStoryboard: UIStoryboard {
        UIStoryboard(name: "Main", bundle: .main)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypBlack
        view.addSubview(logoImageView)
        activateConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = oauth2TokenStorage.token {
            fetchProfile(token: token)
        } else {
            presentAuthViewController()
        }
    }

    // MARK: - View Configuration
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .launchScreenLogo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func presentAuthViewController() {
        guard
            let authViewController = mainStoryboard
                .instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController,
            let navigationController = mainStoryboard
                .instantiateViewController(withIdentifier: "AuthNavigationController") as? AuthNavigationController
        else {
            assertionFailure("Instantiating AuthViewController or AuthNavigationController failed")
            return
        }

        authViewController.delegate = self
        navigationController.viewControllers = [authViewController]
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self else { return }

            UIBlockingProgressHUD.show()
            self.fetchAuthToken(code: code)
        }
    }
}

// MARK: - Fetch data
extension SplashViewController {
    private func fetchAuthToken(code: String) {
        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showAlertWithAuthError()
            }
        }
    }

    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }

            UIBlockingProgressHUD.dismiss()

            switch result {
            case .success(let profile):
                fetchProfileImageURL(userName: profile.username, token: token)
                self.switchToTabBarController()
            case .failure:
                showAlertWithAuthError()
            }
        }
    }
    
    private func fetchProfileImageURL(userName: String, token: String) {
        profileImageService.fetchProfileImageURL(
            userName: userName,
            token: token
        ) { _ in }
    }

    private func showAlertWithAuthError() {
        AlertPresenter.show(in: presentedViewController ?? self, model: Alert.authError)
    }
}
