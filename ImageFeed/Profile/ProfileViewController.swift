//
//  ProfileViewController.swift
//  ImageFeed
//

import UIKit

final class ProfileViewController: UIViewController {
    private enum Constants {
        static let fontSize23: CGFloat = 23
        static let fontSize13: CGFloat = 13
        static let leadingInset: CGFloat = 16
        static let labelTopInset: CGFloat = 8
        static let avatarTopInset: CGFloat = 76
        static let avatarWidthAndHeight: CGFloat = 70
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(avatarImageView)
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)

        activateConstraints()
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

    // MARK: - Constraints
    private var avatarImageViewConstraints: [NSLayoutConstraint] {
        [
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.avatarTopInset),
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

    @objc private func didTapLogoutButton() {
        // TODO: add action
    }
}
