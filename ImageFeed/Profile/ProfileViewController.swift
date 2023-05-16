//
//  ProfileViewController.swift
//  ImageFeed
//

import UIKit

final class ProfileViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private enum Constants {
        static let fontSize23: CGFloat = 23
        static let fontSize13: CGFloat = 13
        static let leadingInset: CGFloat = 16
        static let labelTopInset: CGFloat = 8
        static let avatarTopInset: CGFloat = 32
        static let avatarWidthAndHeight: CGFloat = 70
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(avatarImageView)
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)
        
        configureAndActivateConstraints()
    }
    
    // MARK: - View Configuration
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .avatarImage
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
    
    private func configureAndActivateConstraints() {
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.trailingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(greaterThanOrEqualTo: loginLabel.trailingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.trailingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.avatarTopInset),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.leadingInset),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarWidthAndHeight),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarWidthAndHeight),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.leadingInset),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Constants.labelTopInset),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.leadingInset),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.labelTopInset),
            loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.leadingInset),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: Constants.labelTopInset),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.leadingInset)
        ])
    }

    @objc private func didTapLogoutButton() {
        // TODO: add action
    }
}
