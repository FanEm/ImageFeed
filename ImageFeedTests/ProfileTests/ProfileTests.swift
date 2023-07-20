//
//  ProfileTests.swift
//  ImageFeedTests
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        let _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        presenter.viewDidLoad()

        //then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
    
    func testPresenterCallsUpdateProfileDetails() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        presenter.viewDidLoad()

        //then
        XCTAssertTrue(viewController.updateProfileDetailsCalled)
    }
}
