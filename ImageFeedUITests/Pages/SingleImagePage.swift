//
//  SingleImagePage.swift
//  ImageFeedUITests
//

import XCTest

// MARK: - SingleImagePage
struct SingleImagePage {
    var backButton: XCUIElement {
        view.buttons[AccessibilityIdentifier.SingleImageScreen.backButton]
    }

    var imageView: XCUIElement {
        scrollView.images[AccessibilityIdentifier.SingleImageScreen.imageView]
    }

    func validate() {
        XCTAssertTrue(view.waitForExistence(timeout: 2))
        XCTAssertTrue(imageView.waitForExistence(timeout: 5))
        XCTAssertTrue(scrollView.exists)
        XCTAssertTrue(backButton.exists)
        XCTAssertTrue(shareButton.exists)
    }

    func zoomImageViewIn(withScale: CGFloat = 3, velocity: CGFloat = 1) {
        imageView.pinch(withScale: withScale, velocity: velocity)
    }

    func zoomImageViewOut(withScale: CGFloat = 0.5, velocity: CGFloat = -1) {
        imageView.pinch(withScale: withScale, velocity: velocity)
    }

    // MARK: - Private
    private var view: XCUIElement {
        XCUIApplication().otherElements[AccessibilityIdentifier.SingleImageScreen.view]
    }
    
    private var scrollView: XCUIElement {
        view.scrollViews[AccessibilityIdentifier.SingleImageScreen.scrollView]
    }
    
    private var shareButton: XCUIElement {
        view.buttons[AccessibilityIdentifier.SingleImageScreen.shareButton]
    }
}
