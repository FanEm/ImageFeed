//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    // Необходимо указать данные пользователя для авторизации
    private let user = User(
        login: "<YOUR LOGIN>",
        password: "<YOUR PASSWORD>"

    )
    
    // Необходимо указать данные пользователя для проверки экрана профиля
    private let userProfileData = UserProfileData(
        name: "<USER NAME>",
        login: "<USER LOGIN>",
        description: "<USER DESCRIPTION>"
    )

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments += ["UI-Testing"]
        app.launch()
    }
    
    override func setUp() {
        authorize()
    }

    func testAuth() throws {
        // авторизация происходит в методе setUp
    }
    
    func testFeed() throws {
        let imagesListPage = ImagesListPage()
        let singleImagePage = SingleImagePage()

        imagesListPage.tableView.gentleSwipe(.up)

        let cell = imagesListPage.cell(index: 1)
        var isLiked = cell.likeButton.isSelected
        cell.likeButton.tap()
        waitUntilLikeButtonChangesState(cell: cell, isLiked: isLiked)

        isLiked = cell.likeButton.isSelected
        cell.likeButton.tap()
        waitUntilLikeButtonChangesState(cell: cell, isLiked: isLiked)

        cell.tap()

        singleImagePage.validate()
        singleImagePage.zoomImageViewIn()
        singleImagePage.zoomImageViewOut()
        singleImagePage.backButton.tap()

        XCTAssertTrue(imagesListPage.tableView.waitForExistence(timeout: 2))
    }

    func testProfile() throws {
        let authPage = AuthPage()
        let profilePage = ProfilePage()
        let tabBarPage = TabBarPage()

        tabBarPage.switchToTab(.profile)

        profilePage.validate(userProfileData: userProfileData)
        profilePage.logoutButton.tap()
        profilePage.alertOkButton.tap()

        authPage.validate()
    }
    
    private func authorize() {
        let authPage = AuthPage()
        let imagesListPage = ImagesListPage()
        let webViewPage = WebViewPage()

        authPage.validate()
        authPage.signInButton.tap()

        webViewPage.login(user: user)

        XCTAssertTrue(imagesListPage.cell.waitForExistence(timeout: 5))
    }
    
    private func waitUntilLikeButtonChangesState(cell: ImagesListCell, isLiked: Bool) {
        let predicate = NSPredicate(format:"selected == \(!isLiked)")
        expectation(for: predicate, evaluatedWith: cell.likeButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
