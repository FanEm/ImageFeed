//
//  ImagesListPage.swift
//  ImageFeedUITests
//

import XCTest

// MARK: - ImagesListPage
struct ImagesListPage {
    var tableView: XCUIElement {
        view.tables[AccessibilityIdentifier.ImagesListScreen.tableView]
    }

    var cell: XCUIElement {
        view.cells[AccessibilityIdentifier.ImagesListScreen.Cell.view].firstMatch
    }
    
    func cell(index: Int) -> ImagesListCell {
        let cell = tableView.cells.element(boundBy: index)
        return ImagesListCell(
            imageView: cell.images[AccessibilityIdentifier.ImagesListScreen.Cell.imageView],
            gradientView: cell.images[AccessibilityIdentifier.ImagesListScreen.Cell.gradientView],
            dateLabel: cell.staticTexts[AccessibilityIdentifier.ImagesListScreen.Cell.dateLabel],
            likeButton: cell.buttons[AccessibilityIdentifier.ImagesListScreen.Cell.likeButton]
        )
    }

    // MARK: - Private
    private var view: XCUIElement {
        XCUIApplication().otherElements[AccessibilityIdentifier.ImagesListScreen.view]
    }
}

struct ImagesListCell {
    let imageView: XCUIElement
    let gradientView: XCUIElement
    let dateLabel: XCUIElement
    let likeButton: XCUIElement

    func tap() {
        imageView.tap()
    }
}
