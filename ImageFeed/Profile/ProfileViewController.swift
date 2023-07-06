//
//  ProfileViewController.swift
//  ImageFeed
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private enum Constants {
        static let fontSize23: CGFloat = 23
        static let fontSize13: CGFloat = 13
        static let leadingInset: CGFloat = 16
        static let labelTopInset: CGFloat = 8
        static let avatarTopInset: CGFloat = 32
        static let avatarWidthAndHeight: CGFloat = 70
        static let avatarCornerRadius: CGFloat = 20
    }

    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared

    private var profileImageServiceObserver: NSObjectProtocol?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack

        view.addSubview(avatarImageView)
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)

        activateConstraints()
        updateProfileDetails(profile: profileService.profile)
        profileImageServiceObserver = createProfileImageObserver()
        updateAvatar()
    }

    // MARK: - View Configuration
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .avatarImageStub
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(.exit, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapLogoutButton),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont(name: "SFProText-Bold", size: Constants.fontSize23)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = UIFont(name: "SFProText-Regular", size: Constants.fontSize13)
        label.textColor = .ypGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.font = UIFont(name: "SFProText-Regular", size: Constants.fontSize13)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Constraints
    private var avatarImageViewConstraints: [NSLayoutConstraint] {
        [
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.avatarTopInset),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingInset),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarWidthAndHeight),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarWidthAndHeight)
        ]
    }

    private var logoutButtonConstraints: [NSLayoutConstraint] {
        [
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.leadingInset),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ]
    }

    private var nameLabelConstraints: [NSLayoutConstraint] {
        [
            view.trailingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Constants.labelTopInset),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingInset)
        ]
    }

    private var loginLabelConstraints: [NSLayoutConstraint] {
        [
            view.trailingAnchor.constraint(greaterThanOrEqualTo: loginLabel.trailingAnchor),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.labelTopInset),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingInset)
        ]
    }

    private var descriptionLabelConstraints: [NSLayoutConstraint] {
        [
            view.trailingAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: Constants.labelTopInset),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leadingInset)
        ]
    }

    private func activateConstraints() {
        NSLayoutConstraint.activate(
            avatarImageViewConstraints +
            logoutButtonConstraints +
            nameLabelConstraints +
            loginLabelConstraints +
            descriptionLabelConstraints
        )
    }

    // MARK: - Profile details
    private func updateProfileDetails(profile: Profile?) {
        guard let profile else {
            assertionFailure("There is no profile data")
            return
        }
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }

    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }

        let placeholder: UIImage = .avatarImageStub
        let processor = RoundCornerImageProcessor(cornerRadius: Constants.avatarCornerRadius)

        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.processor(processor),
                      .cacheSerializer(FormatIndicatedCacheSerializer.png)]
        )
    }
    
    private func createProfileImageObserver() -> NSObjectProtocol {
        return NotificationCenter.default
            .addObserver(
                forName: .profileImageProviderDidChange,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
    }

    @objc private func didTapLogoutButton() {
        showLogOutAlert()
    }

    private func showLogOutAlert() {
        let model = AlertModel(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            primaryButtonText: "Да",
            secondaryButtonText: "Нет",
            primaryButtonCompletion: {[weak self] in
                guard let self else { return }
                WebViewViewController.cleanWKData()
                self.oauth2TokenStorage.removeToken()
                self.presentSplashViewController()
            },
            secondaryButtonCompletion: {}
        )
        AlertPresenter.show(in: self, model: model)
    }

    private func presentSplashViewController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let viewController = SplashViewController()
        window.rootViewController = viewController
    }
}
