//
//  WebViewTests.swift
//  ImageFeedTests
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        let _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper(configuration: .standart)
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        presenter.viewDidLoad()

        //then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6

        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        //then
        XCTAssertFalse(shouldHideProgress)
    }

    func testProgressInvisibleWhenMoreThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0

        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)

        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standart
        let helper = AuthHelper(configuration: configuration)

        //when
        let urlString = helper.authRequest().url!.absoluteString

        //then
        XCTAssertTrue(urlString.contains(configuration.authBaseURL.absoluteString))
        XCTAssertTrue(urlString.contains("oauth/authorize"))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        //given
        let helper = AuthHelper()
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: "test code"),
        ]
        let url = urlComponents.url!

        //when
        let code = helper.code(from: url)

        //then
        XCTAssertEqual(code, "test code")
    }
}
