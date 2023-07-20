//
//  TabBarPage.swift
//  ImageFeedUITests
//

import XCTest

// MARK: - TabBarPage
struct TabBarPage {
    func switchToTab(_ tab: TabBarTab) {
        switch tab {
        case .imagesList: imagesListTab.tap()
        case .profile: profileTab.tap()
        }
    }

    // MARK: - Private
    private var view: XCUIElement {
        XCUIApplication().tabBars[AccessibilityIdentifier.TabBar.view]
    }

    private var imagesListTab: XCUIElement {
        view.buttons[AccessibilityIdentifier.TabBar.imagesListTab]
    }

    private var profileTab: XCUIElement {
        view.buttons[AccessibilityIdentifier.TabBar.profileTab]
    }
}

// MARK: - TabBarTab
enum TabBarTab {
    case imagesList
    case profile
}
