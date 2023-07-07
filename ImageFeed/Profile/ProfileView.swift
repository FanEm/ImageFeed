//
//  ProfileView.swift
//  ImageFeed
//

import UIKit

final class ProfileView: UIView {
    private enum Constants {
        static let fontSize23: CGFloat = 23
        static let fontSize13: CGFloat = 13
        static let leadingInset: CGFloat = 16
        static let labelTopInset: CGFloat = 8
        static let avatarTopInset: CGFloat = 32
        static let avatarWidthAndHeight: CGFloat = 70
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .ypBlack
        accessibilityIdentifier = AccessibilityIdentifier.ProfileScreen.view
        addSubview(avatarImageView)
        addSubview(logoutButton)
        addSubview(nameLabel)
        addSubview(loginLabel)
        addSubview(descriptionLabel)

        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Configuration
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .avatarImageStub
        imageView.accessibilityIdentifier = AccessibilityIdentifier.ProfileScreen.avatarImageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(.exit, for: .normal)
        button.accessibilityIdentifier = AccessibilityIdentifier.ProfileScreen.logoutButton
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Bold", size: Constants.fontSize23)
        label.textColor = .ypWhite
        label.accessibilityIdentifier = AccessibilityIdentifier.ProfileScreen.nameLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Regular", size: Constants.fontSize13)
        label.textColor = .ypGray
        label.accessibilityIdentifier = AccessibilityIdentifier.ProfileScreen.loginLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProText-Regular", size: Constants.fontSize13)
        label.textColor = .ypWhite
        label.accessibilityIdentifier = AccessibilityIdentifier.ProfileScreen.descriptionLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Constraints
    private var avatarImageViewConstraints: [NSLayoutConstraint] {
        [
            avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.avatarTopInset),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingInset),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarWidthAndHeight),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarWidthAndHeight)
        ]
    }

    private var logoutButtonConstraints: [NSLayoutConstraint] {
        [
            logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.leadingInset),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ]
    }

    private var nameLabelConstraints: [NSLayoutConstraint] {
        [
            trailingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Constants.labelTopInset),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingInset)
        ]
    }

    private var loginLabelConstraints: [NSLayoutConstraint] {
        [
            trailingAnchor.constraint(greaterThanOrEqualTo: loginLabel.trailingAnchor),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.labelTopInset),
            loginLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingInset)
        ]
    }

    private var descriptionLabelConstraints: [NSLayoutConstraint] {
        [
            trailingAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: Constants.labelTopInset),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingInset)
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
}
