//
//  ProfilePage.swift
//  ImageFeedUITests
//

import XCTest

// MARK: - ProfilePage
struct ProfilePage {
    var logoutButton: XCUIElement {
        view.buttons[AccessibilityIdentifier.ProfileScreen.logoutButton]
    }

    var alertOkButton: XCUIElement {
        XCUIApplication().alerts[AccessibilityIdentifier.Alert.view].buttons["Да"]
    }

    func validate(userProfileData: UserProfileData) {
        XCTAssertTrue(view.waitForExistence(timeout: 2.0))
        XCTAssertTrue(avatarImageView.exists)
        XCTAssertTrue(logoutButton.exists)
        XCTAssertTrue(nameLabel.exists)
        XCTAssertTrue(loginLabel.exists)

        XCTAssertEqual(nameLabel.label, userProfileData.name)
        XCTAssertEqual(loginLabel.label, userProfileData.login)

        if !userProfileData.description.isEmpty {
            XCTAssertTrue(descriptionLabel.exists)
            XCTAssertEqual(descriptionLabel.label, userProfileData.description)
        }
    }

    // MARK: - Private
    private var view: XCUIElement {
        XCUIApplication().otherElements[AccessibilityIdentifier.ProfileScreen.view]
    }

    private var avatarImageView: XCUIElement {
        view.images[AccessibilityIdentifier.ProfileScreen.avatarImageView]
    }

    private var nameLabel: XCUIElement {
        view.staticTexts[AccessibilityIdentifier.ProfileScreen.nameLabel]
    }

    private var loginLabel: XCUIElement {
        view.staticTexts[AccessibilityIdentifier.ProfileScreen.loginLabel]
    }

    private var descriptionLabel: XCUIElement {
        view.staticTexts[AccessibilityIdentifier.ProfileScreen.descriptionLabel]
    }
}
