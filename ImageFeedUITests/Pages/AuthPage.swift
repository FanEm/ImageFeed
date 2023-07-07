//
//  AuthPage.swift
//  ImageFeedUITests
//

import XCTest

// MARK: - AuthPage
struct AuthPage {
    var signInButton: XCUIElement {
        view.buttons[AccessibilityIdentifier.AuthScreen.signInButton]
    }

    func validate() {
        XCTAssertTrue(view.waitForExistence(timeout: 2))
        XCTAssertTrue(logoImageView.exists)
        XCTAssertTrue(signInButton.exists)
    }

    // MARK: - Private
    private var view: XCUIElement {
        XCUIApplication().otherElements[AccessibilityIdentifier.AuthScreen.view]
    }

    private var logoImageView: XCUIElement {
        view.images[AccessibilityIdentifier.AuthScreen.logoImageView]
    }
}
