//
//  WebViewPage.swift
//  ImageFeedUITests
//

import XCTest

// MARK: - WebViewPage
struct WebViewPage {
    func login(user: User) {
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        enterLogin(user.login)
        enterPassword(user.password)

        webView.swipeUp()
        loginButton.tap()
    }

    // MARK: - Private
    private var webView: XCUIElement {
        XCUIApplication().webViews[AccessibilityIdentifier.WebViewScreen.webView]
    }

    private var loginTextField: XCUIElement {
        webView.descendants(matching: .textField).element
    }

    private var passwordTextField: XCUIElement {
        webView.descendants(matching: .secureTextField).element
    }

    private var loginButton: XCUIElement {
        webView.buttons[AccessibilityIdentifier.WebViewScreen.loginButton]
    }

    private func enterLogin(_ login: String) {
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(login)
    }

    private func enterPassword(_ password: String) {
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(password)
    }
}
