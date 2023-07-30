//
//  AuthView.swift
//  ImageFeed
//

import UIKit

// MARK: - AuthView
final class AuthView: UIView {
    private enum Constants {
        static let signInButtonLeadingAndTrailingInset: CGFloat = 16
        static let signInButtonBottomInset: CGFloat = 90
        static let logoWidthAndHeight: CGFloat = 60
        static let signInButtonHeight: CGFloat = 48
        static let fontSize17: CGFloat = 17
        static let signInButtonCornerRadius: CGFloat = 16
    }

    private var signInButtonAction: () -> Void

    init(_ signInButtonAction: @escaping () -> Void) {
        self.signInButtonAction = signInButtonAction

        super.init(frame: .zero)

        backgroundColor = .ypBlack
        accessibilityIdentifier = AccessibilityIdentifier.AuthScreen.view

        addSubview(logoImageView)
        addSubview(signInButton)

        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View elements
    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .authScreenLogo
        imageView.accessibilityIdentifier = AccessibilityIdentifier.AuthScreen.logoImageView
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = Constants.signInButtonCornerRadius
        button.layer.masksToBounds = true
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProText-Bold", size: Constants.fontSize17)
        button.accessibilityIdentifier = AccessibilityIdentifier.AuthScreen.signInButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)

        return button
    }()

    @objc private func onTap() {
        signInButtonAction()
    }

    // MARK: - Constraints
    private var logoImageViewConstraints: [NSLayoutConstraint] {
        [
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.logoWidthAndHeight),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.logoWidthAndHeight)
        ]
    }

    private var signInButtonConstraints: [NSLayoutConstraint] {
        [
            safeAreaLayoutGuide.trailingAnchor.constraint(
                equalTo: signInButton.trailingAnchor,
                constant: Constants.signInButtonLeadingAndTrailingInset
            ),
            signInButton.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.signInButtonLeadingAndTrailingInset
            ),
            safeAreaLayoutGuide.bottomAnchor.constraint(
                equalTo: signInButton.bottomAnchor,
                constant: Constants.signInButtonBottomInset
            ),
            signInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: Constants.signInButtonHeight)
        ]
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate(
            logoImageViewConstraints +
            signInButtonConstraints
        )
    }
}
