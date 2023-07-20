//
//  WebViewView.swift
//  ImageFeed
//

import UIKit
import WebKit

// MARK: - WebViewView
final class WebViewView: UIView {
    private enum Constants {
        static let backButtonWidthAndHeight: CGFloat = 42
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .ypWhite

        addSubview(webView)
        addSubview(backButton)
        addSubview(progressView)

        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View elements
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.accessibilityIdentifier = AccessibilityIdentifier.WebViewScreen.webView
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypWhite
        button.setImage(.backwardBlackIcon, for: .normal)
        button.accessibilityIdentifier = AccessibilityIdentifier.WebViewScreen.backButton
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .ypBlack
        progressView.accessibilityIdentifier = AccessibilityIdentifier.WebViewScreen.progressView
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    // MARK: - Constraints
    private var webViewConstraints: [NSLayoutConstraint] {
        [
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor)
        ]
    }

    private var backButtonConstraints: [NSLayoutConstraint] {
        [
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            backButton.bottomAnchor.constraint(equalTo: progressView.topAnchor),
            backButton.widthAnchor.constraint(equalToConstant: Constants.backButtonWidthAndHeight),
            backButton.heightAnchor.constraint(equalToConstant: Constants.backButtonWidthAndHeight)
        ]
    }
    
    private var progressViewConstraints: [NSLayoutConstraint] {
        [
            progressView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            progressView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor)
        ]
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate(
            webViewConstraints +
            backButtonConstraints +
            progressViewConstraints
        )
    }
}
