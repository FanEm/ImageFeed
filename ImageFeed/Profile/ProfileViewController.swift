//
//  ProfileViewController.swift
//  ImageFeed
//

import UIKit
import Kingfisher

// MARK: - ProfileViewControllerProtocol
protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }

    func updateAvatar(url: URL?)
    func updateProfileDetails(profile: Profile?)
}

// MARK: - ProfileViewController
final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    private enum Constants {
        static let avatarCornerRadius: CGFloat = 60
    }

    var presenter: ProfilePresenterProtocol?

    private lazy var profileView = {
        let view = ProfileView()
        view.logoutButton.addTarget(
            nil,
            action: #selector(didTapLogoutButton),
            for: .touchUpInside
        )
        return view
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        presenter?.viewDidLoad()
    }

    // MARK: - Profile details
    func updateProfileDetails(profile: Profile?) {
        guard let profile else {
            assertionFailure("There is no profile data")
            return
        }
        profileView.nameLabel.text = profile.name
        profileView.loginLabel.text = profile.loginName
        profileView.descriptionLabel.text = profile.bio
    }

    func updateAvatar(url: URL?) {
        guard let url else { return }

        let placeholder: UIImage = .avatarImageStub
        let processor = RoundCornerImageProcessor(cornerRadius: Constants.avatarCornerRadius)

        profileView.avatarImageView.kf.indicatorType = .activity
        profileView.avatarImageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.processor(processor),
                      .cacheSerializer(FormatIndicatedCacheSerializer.png)]
        )
    }

    @objc private func didTapLogoutButton() {
        showLogOutAlert()
    }

    private func showLogOutAlert() {
        let primaryButtonCompletion = {[weak self] in
            guard let self else { return }
            self.presenter?.cleanData()
            self.presentSplashViewController()
        }
        AlertPresenter.show(in: self, model: .logOutAlert(primaryButtonCompletion: primaryButtonCompletion))
    }

    private func presentSplashViewController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let viewController = SplashViewController()
        window.rootViewController = viewController
    }
}
